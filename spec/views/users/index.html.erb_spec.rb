require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :forename => "Forename",
        :surname => "Surname",
        :email => "Email",
        :password => "password",
        :password_confirmation => "password"
      ),
      User.create!(
        :forename => "Forename",
        :surname => "Surname",
        :email => "Email",
        :password => "password",
        :password_confirmation => "password"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Forename".to_s, :count => 2
    assert_select "tr>td", :text => "Surname".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
