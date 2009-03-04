require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LootTable do
  before(:each) do
    @table = LootTable.make
  end
  
  describe "polymorphic associations" do
    it "should take a zone record" do
      @table.zone = Zone.make
      @table.should be_valid
    end
    
    it "should take a boss record" do
      @table.boss = Boss.make
      @table.should be_valid
    end
    
    it "should take an item record" do
      @table.item = Item.make
      @table.should be_valid
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
    
    it "should be able to create a tree" do
    end
  end
end
