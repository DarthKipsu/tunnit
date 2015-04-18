require 'rails_helper'

describe 'Report generation' do
  before(:each) do
    create_user_and_sign_in
    @project = FactoryGirl.create(:project)
    @event = FactoryGirl.create(:event, project_id: @project.id, user_id: @user.id)
    @project2 = FactoryGirl.create(:project, name: 'Other project')
    @event2 = FactoryGirl.create(:event, project_id: @project2.id, user_id: @user.id)
  end

  describe 'creating personal monthly report' do
    before :each do
      visit "/users/1/report/?start_time=1-1-2015&end_time=1-1-2020"
    end

    it 'displays users name on report' do
      expect(page).to have_content 'Mikko Makkonen (test@test.fi)'
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
