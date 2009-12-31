# == Schema Information
#
# Table name: wishlists
#
#  id         :integer(4)      not null, primary key
#  item_id    :integer(4)
#  member_id  :integer(4)
#  priority   :string(255)     default("normal"), not null
#  note       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Wishlist do
  before(:each) do
    @wishlist = Wishlist.make
  end
  it "should be valid" do
    @wishlist.should be_valid
  end
  
  it "should not allow invalid priority types" do
    @wishlist.priority = 'invalid'
    lambda { @wishlist.save! }.should raise_error
  end
  
  it "should not allow nil items" do
    @wishlist.item_id = nil
    lambda { @wishlist.save! }.should raise_error
  end
  
  describe "#item_name" do
    before(:each) do
      Item.destroy_all
    end
    
    it "should return the name of the item" do
      @wishlist.item = Item.make(:name => 'NewItem')
      @wishlist.item_name.should eql('NewItem')
    end
    
    it "should find the name of the existing item when assigned" do
      item = Item.make(:name => 'ExistingItem')
      @wishlist.item_name = 'ExistingItem'
      @wishlist.item_id.should eql(item.id)
    end
    
    it "should create the item if no item was found" do
      lambda {
        # FIXME: This is getting pretty intimate with the way Item works
        ItemLookup.stub!(:search).and_return(valid_lookup_results)
        @wishlist.item_name = 'NewItem'
      }.should change(Item, :count).by(1)
    end
  end
  
  describe "#wow_id" do
    it "should return the wow_id of the Item" do
      @wishlist.item = Item.make(:with_real_stats)
      @wishlist.wow_id.should eql(40395)
    end
  end
end
