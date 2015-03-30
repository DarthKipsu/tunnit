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
    it 'allows user to change password' do
      visit edit_user_path(@user)
      fill_in 'user_password', with: 'Passu2'
      fill_in 'user_password_confirmation', with: 'Passu2'
      click_button 'Change password'
      expect(page).to have_content 'User was successfully updated'
    end

    it 'cant change password if its not valid' do
      visit edit_user_path(@user)
      fill_in 'user_password', with: 'Passu2'
      fill_in 'user_password_confirmation', with: 'Passu3'
      click_button 'Change password'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  describe 'deleting user' do
    pending
  end
end
