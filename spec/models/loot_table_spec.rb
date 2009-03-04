require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LootTable do
  before(:each) do
    @table = LootTable.make
  end
  
  describe "polymorphic associations" do
    before(:each) do
      @zone = Zone.make
      @boss = Boss.make
      @item = Item.make
    end
    it "should take a zone record" do
      @table.zone = @zone
      @table.should be_valid
      @table.zone_type.should == 'Zone'
    end
    
    it "should take a boss record" do
      @table.boss = @boss
      @table.should be_valid
      @table.boss_type.should == 'Boss'
    end
    
    it "should take an item record" do
      @table.item = @item
      @table.should be_valid
      @table.item_type.should == 'Item'
      @table.item.should == @item
      @table.boss.should be_nil
    end
  end
  
  describe "acts_as_tree" do
    before(:each) do
      @table.zone = Zone.make(:name => 'Ulduar')
      @table.children.create(:boss => Boss.make(:name => 'Hodir'))
    end
    
    it "should have children" do
      @table.children.should_not be_nil
    end
  end
end
