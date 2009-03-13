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
end
