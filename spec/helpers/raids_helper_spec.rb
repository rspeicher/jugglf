require 'spec_helper'

describe RaidsHelper do
  describe "#raid_date_classes" do
    it "should populate" do
      raid = mock(:is_in_last_thirty_days? => true, :is_in_last_ninety_days? => false)

      raid_date_classes(raid).strip.should eql('last_thirty')
    end
  end
end
