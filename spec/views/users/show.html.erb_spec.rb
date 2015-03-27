require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :forename => "Forename",
      :surname => "Surname",
      :email => "@Email",
      :password => "rP00password",
      :password_confirmation => "rP00password"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Forename/)
    expect(rendered).to match(/Surname/)
    expect(rendered).to match(/Email/)
  end
end
