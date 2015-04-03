require 'rails_helper'

describe 'teams page' do
  before(:each) do
    create_user_and_sign_in
    @team = FactoryGirl.create(:team)
    @team.users << @user
    @project = FactoryGirl.create(:project, team_id: @team.id)
  end

  it 'displays the team name' do
    visit team_path(@team)
    expect(page).to have_content 'Personal projects'
  end

  describe 'when editing team' do
    it 'changes team name when new name is given' do
      visit edit_team_path(@team)
      fill_form_with 'Edited name'
      expect(page).to have_content 'Team was successfully updated.'
      expect(page).to have_content 'Edited name'
    end

    it 'displays error message when empty name is given' do
      visit edit_team_path(@team)
      fill_form_with ''
      expect(page).to have_content '1 error'
      expect(page).to have_content "Name can't be blank"
    end
  end

  describe 'when creating new team' do
    it 'saves the new team to db when name is given' do
      visit new_team_path
      fill_in 'Name', with: 'Our new team'
      expect{ click_button 'Done' }.to change{ Team.count }.by 1
    end

    it 'displays the new team when name is given' do
      visit new_team_path
      fill_form_with 'Our new team'
      expect(page).to have_content 'Team was successfully created.'
      expect(page).to have_content 'Our new team'
    end

    it 'does not save team to db with no name' do
      visit new_team_path
      expect{ click_button 'Done' }.to change{ Team.count }.by 0
    end

    it 'displays error when no name is given' do
      visit new_team_path
      fill_form_with ''
      expect(page).to have_content '1 error'
      expect(page).to have_content "Name can't be blank"
    end
  end

  describe 'when deleting team' do
    it 'displays message when team is deleted' do
      visit team_path(@team)
      click_link 'Destroy team'
      expect(page).to have_content 'Team was successfully destroyed.'
    end

    it 'removes the team from db' do
      visit team_path(@team)
      expect{ click_link 'Destroy team' }.to change{ Team.count }.by -1
    end

    it 'deletes teams projects as well' do
      visit team_path(@team)
      expect{ click_link 'Destroy team' }.to change{ Project.count }.by -1
    end
  end

  describe 'when leaving team' do
    before :each do
      visit team_path(@team)
    end

    it 'removes the team from user teams' do
      expect{ click_link 'Leave team' }.to change{ @user.teams.count }.by -1
    end

    it 'deletes the team if user was only member in team' do
      expect{ click_link 'Leave team' }.to change{ Team.count }.by -1
    end

    it 'does not delete team if user was not the only member in team' do
      @team.users << FactoryGirl.create(:user, email:'@')
      expect{ click_link 'Leave team' }.to change{ Team.count }.by 0
    end

    it 'displays a message about leaving team' do
      click_link 'Leave team'
      expect(page).to have_content "You're no longer a member of Personal projects"
    end
  end
end

def fill_form_with(name)
  fill_in 'Name', with: name
  click_button 'Done'
end
