require 'rails_helper'

module EventTaskx
  RSpec.describe EventTask, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:event_taskx_event_task)
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:event_taskx_event_task, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil task_category" do
      c = FactoryGirl.build(:event_taskx_event_task, :task_category => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil resource_id" do
      c = FactoryGirl.build(:event_taskx_event_task, :resource_id => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil resource_string" do
      c = FactoryGirl.build(:event_taskx_event_task, :resource_string => nil)
      expect(c).not_to be_valid
    end
    
  end
end
