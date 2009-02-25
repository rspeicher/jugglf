# == Schema Information
# Schema version: 20090225185730
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  price        :float
#  situational  :boolean(1)
#  best_in_slot :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  rot          :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    Member.destroy_all
    @item = Item.make
  end
  
  it "should be valid" do
    @item.should be_valid
  end
  
  it "should return the correct adjusted price for rot items" do
    @item.adjusted_price.should == 1.00
    
    @item.rot = true
    @item.adjusted_price.should == 0.50
  end
  
  it "should know whether or not it affects loot factor" do
    recent_item = Item.make
    recent_item.affects_loot_factor?.should be_true
    
    old_item = Item.make(:raid => Raid.make(:date => 1.year.ago))
    old_item.affects_loot_factor?.should be_false
  end
end
