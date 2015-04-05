require 'rails_helper'

describe 'events page' do
  before(:each) do
    create_user_and_sign_in
    @project2 = FactoryGirl.create(:project, team_id: 99, name: 'Someone elses')
    @event2 = FactoryGirl.create(:event, project_id: @project2.id)
    @team = FactoryGirl.create(:team)
    @team.users << @user
    @project = FactoryGirl.create(:project, team_id: @team.id)
    @event = FactoryGirl.create(:event, project_id: @project.id)
  end

  describe 'calendar view' do
    before :all do
      self.use_transactional_fixtures = false
    end

    before :each do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
      visit events_path
    end

    after :each do
      DatabaseCleaner.clean
    end

    after :all do
      self.use_transactional_fixtures = true
    end

    it 'displays events', js:true do
      expect(first('.fc-title')).to have_content @event.title
    end

    it 'only displays users own events', js:true do
      expect(first('.fc-title')).not_to have_content @event2.title
    end
  end

  describe 'when adding a new event' do
    before :each do
      visit new_event_path
    end

    it 'adds a new event to database if everything is ok' do
      fill_in 'start', with: '12:00'
      fill_in 'time', with: '3h'
      expect{ click_button 'Submit' }.to change{ Event.count }.by 1
    end

    it 'adds new event when time is seperated with point' do
      fill_in 'start', with: '12:00'
      fill_in 'time', with: '1.5 h'
      expect{ click_button 'Submit' }.to change{ Event.count }.by 1
    end

    it 'adds new event when time has something extra in the end' do
      fill_in 'start', with: '12:00'
      fill_in 'time', with: '2 tuntia'
      expect{ click_button 'Submit' }.to change{ Event.count }.by 1
    end

    it 'displays success message when event added successfully' do
      fill_event_with '12:00', '45 min'
      expect(page).to have_content 'Event was successfully created.'
      expect(page).to have_content '12:00 - 12:45'
      expect(page).to have_content '0.8 h'
    end

    it 'does not add new db object if errors occured' do
      expect{ click_button 'Submit' }.to change{ Event.count }.by 0
    end

    it 'displays a message about the error when start time is incorrect' do
      fill_event_with '', '3 h'
      expect(page).to have_content 'Incorrect start time'
    end

    it 'displays a message about the error when one happens' do
      fill_event_with '4:25 pm', ''
      expect(page).to have_content '1 error'
      expect(page).to have_content 'End must be after'
    end
  end

  describe 'when editing event' do
    before :each do
      visit edit_event_path(@event)
    end

    it 'displays a success message when event successfully updated' do
      click_button 'Done'
      expect(page).to have_content 'Event was successfully updated.'
    end

    it 'displays error when event updated with errors' do
      select '2016', from: 'event[start(1i)]'
      select '2015', from: 'event[end(1i)]'
      click_button 'Done'
      expect(page).to have_content '1 error'
      expect(page).to have_content 'End must be after'
    end
  end

  describe 'when deleting event' do
    before :each do
      visit event_path(@event)
    end

    it 'displays message when event is deleted' do
      click_link 'Delete event'
      expect(page).to have_content 'Event was successfully destroyed.'
    end

    it 'removes the event from db' do
      expect{ click_link 'Delete event' }.to change{ Event.count }.by -1
    end
  end
end

def fill_event_with(start, spent)
  fill_in 'start', with: start
  fill_in 'time', with: spent
  click_button 'Submit'
end
