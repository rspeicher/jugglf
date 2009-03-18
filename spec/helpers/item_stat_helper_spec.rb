require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ItemStatsHelper

describe ItemStatsHelper do
  before(:each) do
    @stat = ItemStat.make
    @item = Item.make(:name => 'MyItem')
    
    ItemStat.stub!(:lookup).and_return(@stat)
  end
  
  describe "link_to_wowhead" do
    it "should return nil for nil stats" do
      ItemStat.stub!(:lookup).and_return(nil)
      
      link_to_wowhead(@item).should == nil
    end
    
    it "should link to wowhead" do
      link_to_wowhead(@item).should match(/wowhead.com\/\?item=12345/)
    end
    
    it "should include the quality class" do
      link_to_wowhead(@item).should match(/class='q4'/)
    end
    
    it "should include the item name" do
      link_to_wowhead(@item).should match(/MyItem/)
    end
    
    it "should use existing item_stat if available" do
      @item.stub!(:item_stat).and_return(@stat)
      ItemStat.should_not_receive(:lookup)
      link_to_wowhead(@item).should match(/MyItem/)
    end
  end
  
  describe "link_to_item_with_stats" do
    it "should return nil for nil stats" do
      ItemStat.stub!(:lookup).and_return(nil)
      
      link_to_item_with_stats(@item).should == nil
    end
    
    it "should include the item path" do
      link_to_item_with_stats(@item).should match(/href='\/items\/[0-9]+-myitem'/)
    end
    
    it "should include a relative item link for tooltips" do
      link_to_item_with_stats(@item).should match(/rel='item=12345'/)
    end
    
    it "should include the quality class" do
      link_to_item_with_stats(@item).should match(/class='q4'/)
    end
    
    it "should include the item name" do
      link_to_item_with_stats(@item).should match(/MyItem/)
    end
    
    it "should use existing item_stat if available" do
      @item.stub!(:item_stat).and_return(@stat)
      ItemStat.should_not_receive(:lookup)
      link_to_item_with_stats(@item).should match(/MyItem/)
    end
  end
end
