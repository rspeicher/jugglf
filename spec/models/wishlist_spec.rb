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

require 'spec_helper'

describe Wishlist do
  before(:each) do
    @wishlist = Factory(:wishlist)
  end

  it "should be valid" do
    @wishlist.should be_valid
  end

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should allow_mass_assignment_of(:item_id) }
    it { should allow_mass_assignment_of(:item_name) }
    it { should allow_mass_assignment_of(:member_id) }
    it { should allow_mass_assignment_of(:priority) }
    it { should allow_mass_assignment_of(:note) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
    it { should allow_mass_assignment_of(:wow_id) }
  end

  context "associations" do
    it { should belong_to(:item) }
    it { should belong_to(:member) }
  end

  context "validations" do
    it { should_not allow_value(nil).for(:priority) }
    it { should_not allow_value('invalid').for(:priority) }
    it { should allow_value('best in slot').for(:priority) }
    
    it "should invalidate on nil item" do
      @wishlist.item_id = nil
      lambda { @wishlist.save! }.should raise_error
    end

    it "should invalidate on non-authentic item" do
      @wishlist.item = Factory.build(:item, :authentic => false)
      lambda {
        @wishlist.save!
      }.should raise_error
    end
  end
end

describe Wishlist, "#item_name" do
  before(:each) do
    @wishlist = Factory(:empty_wishlist)
    @item     = Factory(:item)
  end

  it "should return the name of the item" do
    @wishlist.item = @item
    @wishlist.item_name.should eql(@item.name)
  end

  it "should find the name of the existing item when assigned" do
    @wishlist.item_name = @item.name
    @wishlist.item_id.should eql(@item.id)
  end

  it "should create the item if no item was found" do
    # Stub this so we don't perform an item lookup; we only care that it's being called
    Item.should_receive(:find_or_create_by_name_or_id).with('NewItem')
    @wishlist.item_name = 'NewItem'
  end
end

describe Wishlist, "#wow_id" do
  before(:each) do
    @wishlist = Factory(:empty_wishlist)
    @item     = Factory(:item)
  end

  it "should return the id of the Item" do
    @wishlist.item = @item
    @wishlist.wow_id.should eql(@item.id)
  end

  it "should assign via wow_id" do
    @wishlist.wow_id = @item.id
    @wishlist.item.should eql(@item)
  end
end