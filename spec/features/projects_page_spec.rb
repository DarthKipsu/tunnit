require 'rails_helper'

describe 'project page' do
  before(:each) do
    create_user_and_sign_in
    @team = FactoryGirl.create(:team)
    @team.users << @user
    @project = FactoryGirl.create(:project, team_id: @team.id)
    @event = FactoryGirl.create(:event, project_id: @project.id)
  end

  it 'displays project name on project page' do
    visit project_path(@project)
    expect(page).to have_content 'My project'
  end

  describe 'when creating a new project' do
    before :each do
      visit new_project_path
    end

    it 'saves a new project to db when a name is provided' do
      fill_in 'Name', with: 'New Project'
      expect{ click_button 'Done' }.to change{ Project.count }.by 1
    end

    it 'does not save a project with no name' do
      expect{ click_button 'Done' }.to change{ Project.count }.by 0
    end

    it 'displays an error message when no name is provided' do
      fill_form_with nil
      expect(page).to have_content '1 error'
      expect(page).to have_content "Name can't be blank"
    end

    it 'displays the new project on top of project lists' do
      fill_form_with 'New Project'
      visit teams_path
      expect(find('.well').find('div:nth-child(2)').find('p:first-child')).to have_content 'New Project'
    end
  end

  describe 'when editing project' do
    before :each do
      visit edit_project_path(@project)
    end

    it 'changes the project name when name is changed' do
      fill_form_with 'New name'
      expect(page).to have_content 'Project was successfully updated.'
      expect(page).to have_content 'New name'
    end

    it 'displays error when name is edited to be empty' do
      fill_form_with ''
      expect(page).to have_content '1 error'
      expect(page).to have_content "Name can't be blank"
    end
  end

  describe 'when deleting project' do
    before :each do
      visit project_path(@project)
    end

    it 'displays message when project is deleted' do
      click_link 'Delete project'
      expect(page).to have_content 'Project was successfully destroyed.'
    end

    it 'removes the project from db' do
      expect{ click_link 'Delete project' }.to change{ Project.count }.by -1
    end

    it 'deletes projects events as well' do
      expect{ click_link 'Delete project' }.to change{ Event.count }.by -1
    end
  end
end

def fill_form_with(name)
  fill_in 'Name', with: name
  click_button 'Done'
end
