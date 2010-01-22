require 'spec_helper'

include Members::WishlistsHelper

describe "group_wishlist_notes" do
  before(:each) do
    @wishlist = Factory(:wishlist)
    @wishlists = [@wishlist]
  end

  it "should return an empty hash if param is blank" do
    group_wishlist_notes([]).should eql({})
  end

  it "should have Item IDs as keys" do
    group_wishlist_notes(@wishlists).should have_key(@wishlist.item_id)
  end

  it "should have wishlist priority and note" do
    group_wishlist_notes(@wishlists)[@wishlist.item.wow_id][0].should have_key(:priority)
    group_wishlist_notes(@wishlists)[@wishlist.item.wow_id][0].should have_key(:note)
  end
end