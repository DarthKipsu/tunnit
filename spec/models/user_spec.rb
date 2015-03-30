require 'rails_helper'

describe User do
  describe "validation" do
    it "should pass with valid password and email" do
      user = FactoryGirl.build(:user)
      expect(user).to be_valid
    end

    it "should fail for having less than 4 characters in password" do
      user = FactoryGirl.build(:user, password: "12P", password_confirmation: "12P")
      expect(user).to_not be_valid
    end

    it "should fail for having no capital letters in password" do
      user = FactoryGirl.build(:user, password: "f00bar", password_confirmation: "f00bar")
      expect(user).to_not be_valid
    end

    it "should fail for having no numbers in password" do
      user = FactoryGirl.build(:user, password: "Foobar", password_confirmation: "Foobar")
      expect(user).to_not be_valid
    end

    it "should fail for having no @ in email" do
      user = FactoryGirl.build(:user, email: "foobar.fi")
      expect(user).to_not be_valid
    end
  end
end
