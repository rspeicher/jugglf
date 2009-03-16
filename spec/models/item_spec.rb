# == Schema Information
# Schema version: 20090312150316
#
# Table name: items
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  item_stat_id    :integer(4)
#  wishlists_count :integer(4)      default(0)
#  loots_count     :integer(4)      default(0)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @item = Item.make
  end
  
  it "should be valid" do
    @item.should be_valid
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
  end
end
