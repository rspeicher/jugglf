# == Schema Information
# Schema version: 20090404033151
#
# Table name: loot_tables
#
#  id          :integer(4)      not null, primary key
#  object_id   :integer(4)
#  object_type :string(255)
#  parent_id   :integer(4)
#  note        :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LootTable do
  before(:each) do
    @table = LootTable.make
  end
  
  it "should return its object's name for to_s" do
    @table.object = Boss.make(:name => 'Boss')
    @table.to_s.should == 'Boss'
  end
  
  describe "polymorphic associations" do
    before(:each) do
      @zone = Zone.make
      @boss = Boss.make
      @item = Item.make
    end
    it "should take a zone record" do
      @table.object = @zone
      @table.should be_valid
      @table.object_type.should == 'Zone'
    end
    
    it "should take a boss record" do
      @table.object = @boss
      @table.should be_valid
      @table.object_type.should == 'Boss'
    end
    
    it "should take an item record" do
      @table.object = @item
      @table.should be_valid
      @table.object_type.should == 'Item'
      @table.object.should == @item
    end
  end
  
  it "should act as tree" do
    @table.object = Zone.make(:name => 'Ulduar')
    @table.children.create(:object => Boss.make(:name => 'Hodir'))
    @table.children.should_not be_nil
  end
end
