require 'spec_helper'

module EventTaskx
  describe EventTask do
    it "should be OK" do
      c = FactoryGirl.build(:event_taskx_event_task)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:event_taskx_event_task, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject nil task_category" do
      c = FactoryGirl.build(:event_taskx_event_task, :task_category => nil)
      c.should_not be_valid
    end
    
    it "should reject nil resource_id" do
      c = FactoryGirl.build(:event_taskx_event_task, :resource_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil resource_string" do
      c = FactoryGirl.build(:event_taskx_event_task, :resource_string => nil)
      c.should_not be_valid
    end
    
  end
end
