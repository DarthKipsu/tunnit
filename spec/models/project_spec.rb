require 'rails_helper'

describe Project do
  describe "validation" do
    it "should pass with valid project name and a team" do
      project = FactoryGirl.build(:project)
      expect(project).to be_valid
    end

    it "should fail for having no name" do
      project = FactoryGirl.build(:project, name: nil)
      expect(project).to_not be_valid
    end

    it "should fail for having no team" do
      project = FactoryGirl.build(:project, team_id: nil)
      expect(project).to_not be_valid
    end
  end

  describe "deletion" do
    before(:each) do
      @project = FactoryGirl.create(:project)
      @event = FactoryGirl.create(:event, project_id: @project.id)
    end

    it "should have one event before deletion" do
      expect(Event.count).to eq(1)
    end

    it "should have no events after deletion" do
      @project.destroy
      expect(Event.count).to eq(0)
    end
  end
end
