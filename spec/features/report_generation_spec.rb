require 'rails_helper'

describe 'Report generation' do
  before(:each) do
    create_user_and_sign_in
    @project = FactoryGirl.create(:project)
    @event = FactoryGirl.create(:event, project_id: @project.id)
    @project2 = FactoryGirl.create(:project, name: 'Other project')
    @event2 = FactoryGirl.create(:event, project_id: @project2.id)
  end

  describe 'creating personal monthly report' do
    before :each do
      fill_in 'start_time', with: (Time.now - 1.week).to_s
      fill_in 'end_time', with: (Time.now).to_s
      click_button 'Generate report'
    end

    it 'displays users name on report' do
      expect(page).to have_content 'Mikko Makkonen'
    end

    it 'displays correct total hours' do
      expect(page).to have_content '4.0 h'
    end

    it 'displays all projects' do
      expect(page).to have_content 'My project 2.0 hours'
      expect(page).to have_content 'Other project 2.0 hours'
    end
  end
end
