require 'rails_helper'

describe "Sign in" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    visit signin_path
  end

  it "should display welcome message when signed in with correct credentials" do
    sign_in_with('test@test.fi', 'Salainen1')
    expect(page).to have_content 'Mikko Makkonen'
  end

  it "should display info message when incorrect credentials" do
    sign_in_with('test@test.fi', 'VaaraPassu')
    expect(page).to have_content 'Email and/or password mismatch'
  end
end

describe "Sign out" do
  it "should send user back to signin page" do
    create_user_and_sign_in
    click_link 'Signout'
    expect(page).to have_content 'Sign in'
    expect(page).not_to have_content 'You should be signed in'
  end
end

def sign_in_with(email, pass)
  fill_in 'email', with: email
  fill_in 'password', with: pass
  click_button 'Log in'
end
