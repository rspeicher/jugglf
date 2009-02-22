require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include RaidsHelper

describe RaidsHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the RaidsHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(RaidsHelper)
  end
  
  describe "task" do
    it "should populate raid_date_classes" # do
     #      raid = mock('raid')
     #      raid.should_receive(:is_in_last_thirty_days?).and_return(true)
     #      raid.should_receive(:is_in_last_ninety_days?).and_return(false)
     #    
     #      raid_date_classes(raid).strip.should == 'last_thirty'
     #    end
  end
end
