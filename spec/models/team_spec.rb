require 'rails_helper'

describe Team do
  describe "validation" do
    it "should pass with valid team name" do
      team = FactoryGirl.build(:team)
      expect(team).to be_valid
    end

    it "should fail for having no name" do
      team = FactoryGirl.build(:team, name: nil)
      expect(team).to_not be_valid
    end
  end

  describe "deletion" do
    before(:each) do
      @team = FactoryGirl.create(:team)
      @project = FactoryGirl.create(:project, team_id: @team.id)
    end

    it "should have one project before deletion" do
      expect(Project.count).to eq(1)
    end

    it "should have no projects after deletion" do
      @team.destroy
      expect(Project.count).to eq(0)
    end
  end
end
