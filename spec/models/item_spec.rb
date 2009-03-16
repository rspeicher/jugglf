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
  
  # describe "#safely_rename" do
  #   before(:each) do
  #     @wrong = Item.make(:name => 'Wrong')
  #     5.times { @wrong.loots.make }
  #     
  #     @right = Item.make(:name => 'Right')
  #     3.times { @right.loots.make }
  #   end
  # 
  #   it "should update its loot children" do
  #     Item.safely_rename(:from => @wrong, :to => @right.id)
  #     
  #     Item.find_by_name('Wrong').should be_nil
  #     
  #     @right.reload
  #     @right.loots.count.should == 8
  #   end
  #   
  #   it "should update its wishlist children"
  #   
  #   it "should update its loot_table children"
  # end
end
