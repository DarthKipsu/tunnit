require 'rails_helper'

describe 'teams request page' do
  before(:each) do
    create_user_and_sign_in
    @user2 = FactoryGirl.create(:user, email: 'my@friend.com')
    @team = FactoryGirl.create(:team)
    @team.users << @user
  end
  
  it 'can add members from team page' do
    visit team_path(@team)
    click_link 'Add a member'
    fill_in 'email', with: 'my@friend.com'
    click_button 'Send request'
    expect(page).to have_content 'Request to join the team was sent!'
  end

  it "displays an error when request email can't be found" do
    visit add_member_path(@team)
    fill_in 'email', with: 'not@found.email'
    click_button 'Send request'
    expect(page).to have_content 'User not found'
  end
end
