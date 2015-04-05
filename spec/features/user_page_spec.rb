require 'rails_helper'

describe 'User page' do
  before(:each) do
    create_user_and_sign_in
  end

  it "display user name and email" do
    expect(page).to have_content 'Mikko Makkonen'
    expect(page).to have_content 'test@test.fi'
  end

  it "displays users teams and projects" do
    expect(page).to have_content 'Teams:'
    expect(page).to have_content 'Projects:'
  end

  describe 'acces to other users information' do
    before :each do
      @user2 = FactoryGirl.create(:user, email:'@', forename: 'KK', surname: 'Kojootti')
      @team = FactoryGirl.create(:team)
      @project = FactoryGirl.create(:project, team_id: @team.id)
      @team.users << @user2
    end

    it 'does not display user info if member not in same team' do
      visit user_path(@user2)
      expect(page).to have_content 'Forbidden access'
    end

    it 'displays team members info' do
      @team.users << @user
      visit user_path(@user2)
      expect(page).to have_content 'KK Kojootti'
    end
  end

  describe 'when editing user' do
    before :each do
      visit edit_user_path(@user)
      fill_in 'user_password', with: 'Passu2'
    end

    it 'allows user to change password' do
      fill_in 'user_password_confirmation', with: 'Passu2'
      click_button 'Change password'
      expect(page).to have_content 'Account was successfully updated'
    end

    it 'cant change password if its not valid' do
      fill_in 'user_password_confirmation', with: 'Passu3'
      click_button 'Change password'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  describe 'when deleting user' do
    before :each do
      visit user_path(@user)
    end

    it 'displays message when user is deleted' do
      click_link 'Delete account'
      expect(page).to have_content 'Account was successfully destroyed.'
    end

    it 'removes the user from db' do
      expect{ click_link 'Delete account' }.to change{ User.count }.by -1
    end
  end
end
