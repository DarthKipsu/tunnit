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
      expect(page).to have_content 'Mikko Makkonen'
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

  describe 'when sent team requests' do
    it 'displays no message while request is pending' do
      @request = FactoryGirl.create(:team_request, source_id: 1, target_id: 2)
      visit user_path(@user)
      expect(page).not_to have_content 'Team requests you have sent have changed'
    end

    it 'displays a message after request has been accepted' do
      @request = FactoryGirl.create(:team_request, team_id: 1, source_id: 1, target_id: 2, status: 'accepted')
      visit user_path(@user)
      expect(page).to have_content 'Team requests you have sent have changed'
      expect(page).to have_content 'Mikko accepted'
    end

    it 'displays a message after request has been declined' do
      @request = FactoryGirl.create(:team_request, team_id: 1, source_id: 1, target_id: 2, status: 'declined')
      visit user_path(@user)
      expect(page).to have_content 'Team requests you have sent have changed'
      expect(page).to have_content 'Mikko declined'
    end

    it 'displays the message only once' do
      @request = FactoryGirl.create(:team_request, team_id: 1, source_id: 1, target_id: 2, status: 'declined')
      visit user_path(@user)
      visit user_path(@user)
      expect(page).not_to have_content 'Team requests you have sent have changed'
    end
  end
end
