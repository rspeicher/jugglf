require 'spec_helper'

describe Wishlist do
  subject { Factory(:wishlist) }

  it { should be_valid }

  context "mass assignment" do
    [:id, :member_id, :created_at, :updated_at].each do |a|
      it { should_not allow_mass_assignment_of(a) }
    end

    [:item_id, :item_name, :priority, :note].each do |a|
      it { should allow_mass_assignment_of(a) }
    end
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
      subject.item = nil
      lambda { subject.save! }.should raise_error
    end

    it "should invalidate on non-authentic item" do
      subject.item = Factory.build(:item, :authentic => false)
      lambda { subject.save! }.should raise_error
    end
  end
end

describe Wishlist, "#item_name" do
  before do
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
    Item.expects(:find_or_create_by_name_or_id).with('NewItem')
    @wishlist.item_name = 'NewItem'
  end
end
