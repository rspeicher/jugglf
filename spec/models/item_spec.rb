# == Schema Information
# Schema version: 20090717234345
#
# Table name: items
#
#  id              :integer(4)      not null, primary key
#  name            :string(100)
#  wishlists_count :integer(4)      default(0)
#  loots_count     :integer(4)      default(0)
#  wow_id          :integer(4)
#  color           :string(15)
#  icon            :string(255)
#  level           :integer(4)      default(0)
#  slot            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @item = Item.make
  end
  
  it "should be valid" do
    @item.should be_valid
  end
  
  it "should have custom to_param" do
    @item.to_param.should == "#{@item.id}-#{@item.name.parameterize}"
  end
  
  describe "#use_proper_name" do
    before(:each) do
      @item.name = 'this name needs to be fixed'
      @stat = ItemStat.make_unsaved
    end
    
    it "should not change the name if we have no item stat record" do
      @item.item_stat = nil
      lambda { @item.save }.should_not change(@item, :name)
    end
    
    it "should not change the name if the item stat record name is nil" do
      @stat.item = nil
      @item.item_stat = @stat
      lambda { @item.save }.should_not change(@item, :name)
    end
    
    it "should change the name if the item stat record appears valid" do
      @stat.item = 'Proper Name'
      @item.item_stat = @stat
      lambda { @item.save }.should change(@item, :name).to('Proper Name')
    end
  end
  
  describe "#safely_rename" do
    before(:each) do
      @wrong = Item.make(:name => 'Wrong')
      @right = Item.make(:name => 'Right')
    end
    
    it "should delete the old item" do
      Item.safely_rename(:from => @wrong, :to => @right.id)
      Item.find_by_name('Wrong').should be_nil
    end
  
    it "should update its loot children" do
      1.times { @wrong.loots.make }
      5.times { @right.loots.make }
      
      Item.safely_rename(:from => @wrong, :to => @right.id)
      
      @right.reload
      @right.loots.count.should == 6
      @right.loots_count.should == 6
    end
    
    it "should update its wishlist children" do
      4.times { @wrong.wishlists.make }
      2.times { @right.wishlists.make }
      
      Item.safely_rename(:from => @wrong, :to => @right.id)
      
      @right.reload
      @right.wishlists.count.should == 6
      @right.wishlists_count.should == 6
    end
    
    it "should update its loot table children" do
      1.times { @wrong.loot_tables.make }
      
      Item.safely_rename(:from => @wrong, :to => @right.id)
      
      @right.reload
      @right.loot_tables.count.should == 1
    end
    
    it "should accept a string for each argument" do
      lambda { Item.safely_rename(:from => 'Wrong', :to => 'Right') }.should_not raise_error
    end
  end
end
