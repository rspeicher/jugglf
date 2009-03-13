# == Schema Information
# Schema version: 20090312150316
#
# Table name: loots
#
#  id           :integer(4)      not null, primary key
#  item_id      :integer(4)
#  price        :float
#  purchased_on :date
#  best_in_slot :boolean(1)
#  situational  :boolean(1)
#  rot          :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Loot do
  before(:each) do
    @loot = Loot.make
  end
  
  it "should be valid" do
    @loot.should be_valid
  end
  
  it "should return the correct adjusted price for rot loots" do
    @loot.adjusted_price.should == 1.00
    
    @loot.rot = true
    @loot.adjusted_price.should == 0.50
  end
  
  it "should know whether or not it affects loot factor" do
    @loot.affects_loot_factor?.should be_true
    
    @loot.purchased_on = 1.year.ago
    @loot.affects_loot_factor?.should be_false
  end
end
