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

  describe 'when pending team requests' do
    before :each do
      @team2 = FactoryGirl.create(:team, name: 'Shared team')
      @request = FactoryGirl.create(:team_request)
      visit user_path(@user)
    end

    it 'displays a flash message about the pending requests' do
      expect(page).to have_content 'You have pending team requests'
      expect(page).to have_content 'Shared team'
    end

    it 'adds the team to users teams when accepted' do
      expect{ click_link 'Accept' }.to change{ @user.teams.count }.by 1
    end

    it 'displays a flash message about joining team when accepted' do
      click_link 'Accept'
      expect(page).to have_content 'Joined team Shared team'
    end

    it 'does not add team to users teams when declined' do
      expect{ click_link 'Decline' }.to change{ @user.teams.count }.by 0
    end

    it 'stops displaying the request once if declined' do
      click_link 'Decline'
      expect(page).not_to have_content 'You have pending team requests'
      expect(page).to have_content 'Request declined'
    end
  end
end
