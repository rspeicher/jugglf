require 'spec_helper'

include RaidsHelper

describe RaidsHelper do
  describe "raid_date_classes" do
    it "should populate" do
      raid = mock(Raid)
      raid.should_receive(:is_in_last_thirty_days?).and_return(true)
      raid.should_receive(:is_in_last_ninety_days?).and_return(false)
  
      raid_date_classes(raid).strip.should eql('last_thirty')
    end
  end
end
