# == Schema Information
# Schema version: 20090225185730
#
# Table name: item_stats
#
#  id         :integer(4)      not null, primary key
#  item_id    :integer(4)
#  item       :string(255)
#  locale     :string(10)      default("en")
#  color      :string(15)
#  icon       :string(255)
#  level      :integer(8)      default(0)
#  slot       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemStat do
  before(:each) do
    @stat = ItemStat.make
  end
  
  it "should return a Wowhead item link" do
    @stat.wowhead_link.should == "http://www.wowhead.com/?item=12345"
  end
  
  it "should return a Wowhead icon link" do
    @stat.wowhead_icon('medium').should == "http://static.wowhead.com/images/icons/medium/inv_icon_01.jpg"
  end
end

describe ItemStat, "lookup from database" do
  before(:each) do
    @stat = ItemStat.make(:real)
  end
  
  it "should perform lookup by item id" do
    ItemStat.lookup(@stat.item_id).should == @stat
  end
  
  it "should perform lookup by item name" do
    ItemStat.lookup(@stat.item).should == @stat
  end
end
  
describe ItemStat, "lookup from Wowhead" do
  before(:each) do
    ItemStat.destroy_all
    @stat = ItemStat.make(:real)
    
    ItemStat.stub!(:wowhead_fetch).
      and_return(File.read(RAILS_ROOT + '/spec/fixtures/wowhead/item_40395.xml'))
  end
  
  it "should perform lookup by item id" do
    stat = ItemStat.lookup(40395, true) # Force a refresh
    
    stat.should == @stat
  end
  
  it "should perform lookup by item name" do
    stat = ItemStat.lookup('TORCH OF HOLY FIRE', true) # Force a refresh

    stat.should == @stat
  end
end
