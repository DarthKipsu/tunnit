require 'rails_helper'

describe "Sign up" do
  before(:each) do
    visit signup_path
  end

  it "with valid credentials adds a new User" do
    signup_with("Tapsa", "Testaaja", "asd@testi.fi", "Tapsa1", "Tapsa1")
    expect{ click_button('Create User') }.to change{ User.count }.by 1
  end

  it "with valid credentials displays the user a success message" do
    signup_with("Tapsa", "Testaaja", "asd@testi.fi", "Tapsa1", "Tapsa1")
    click_button('Create User')
    expect(page).to have_content 'Tapsa Testaaja'
  end

  it "with invalid credentials does not add a new User" do
    signup_with("Tapsa", "Testaaja", "asd@testi.fi", "Tapsa1", "Tapsa2")
    expect{ click_button('Create User') }.to change{ User.count }.by 0
  end

  it "with invalid credentials displays the user a message" do
    signup_with("Tapsa", "Testaaja", "asd", "Tapsa1", "Tapsa1")
    click_button('Create User')
    expect(page).to have_content '1 error prohibited this user from being saved:'
    expect(page).to have_content 'Email is invalid'
  end

  it "with several invalid credentials displays the user a message with all the errors" do
    signup_with("Tapsa", "Testaaja", "asd", "ta", "Ta")
    click_button('Create User')
    expect(page).to have_content '4 errors prohibited this user from being saved:'
  end
end

def signup_with(fn, sn, email, pass, pass_conf)
    fill_in "Forename", with: fn
    fill_in "Surname", with: sn
    fill_in "Email", with: email
    fill_in "Password", with: pass
    fill_in "Password confirmation", with: pass_conf
end
