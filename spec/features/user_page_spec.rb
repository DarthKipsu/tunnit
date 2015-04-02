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

  describe 'when editing user' do
    before :each do
      visit edit_user_path(@user)
      fill_in 'user_password', with: 'Passu2'
    end

    it 'allows user to change password' do
      fill_in 'user_password_confirmation', with: 'Passu2'
      click_button 'Change password'
      expect(page).to have_content 'Your information'
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
