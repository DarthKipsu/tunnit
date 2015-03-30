require 'rails_helper'

describe Event do
  describe "validation" do
    it "should pass with valid parameters" do
      event = FactoryGirl.build(:event)
      expect(event).to be_valid
    end

    it "should fail for having no title" do
      event = FactoryGirl.build(:event, title: nil)
      expect(event).to_not be_valid
    end

    it "should fail for having no project" do
      event = FactoryGirl.build(:event, project_id: nil)
      expect(event).to_not be_valid
    end

    it "should fail for having begin time after end time" do
      event = FactoryGirl.build(:event, start: DateTime.parse('2015,3,30 13:14'))
      expect(event).to_not be_valid
    end
  end
end
