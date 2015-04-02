require 'rails_helper'

describe TeamRequest do
  describe 'validation' do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it "should pass with valid parameters" do
      request = FactoryGirl.build(:team_request)
      expect(request).to be_valid
    end

    it "should fail for having no source" do
      request = FactoryGirl.build(:team_request, source_id: nil)
      expect(request).not_to be_valid
    end

    it "should fail for having no target" do
      request = FactoryGirl.build(:team_request, target_id: nil)
      expect(request).not_to be_valid
    end

    it "should fail for having no team" do
      request = FactoryGirl.build(:team_request, team_id: nil)
      expect(request).not_to be_valid
    end

    it "should pass when target user is member of another team" do
      @user.teams << FactoryGirl.create(:team)
      request = FactoryGirl.build(:team_request, team_id: 2)
      expect(request).to be_valid
    end

    it "should pass when target user already has pending request for another team" do
      request1 = FactoryGirl.create(:team_request)
      request2 = FactoryGirl.build(:team_request, team_id: 2)
      expect(request2).to be_valid
    end

    it "should fail if target user is already a member of the team" do
      @user.teams << FactoryGirl.create(:team)
      request = FactoryGirl.build(:team_request)
      expect(request).not_to be_valid
    end

    it "should fail if target user already has pending request for the team" do
      request1 = FactoryGirl.create(:team_request)
      request2 = FactoryGirl.build(:team_request)
      expect(request2).not_to be_valid
    end
  end
end
