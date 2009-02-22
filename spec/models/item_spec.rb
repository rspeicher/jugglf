# == Schema Information
# Schema version: 20090213233547
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  price        :float           default(0.0)
#  situational  :boolean(1)
#  best_in_slot :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  rot          :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @item = Item.make
  end
  
  it "should be valid" do
    @item.should be_valid
  end
  
  it "should return the correct adjusted price for rot items" do
    @item.adjusted_price.should == 1.00
    
    @item.rot = true
    @item.adjusted_price.should == 0.50
  end
  
  it "should allow multiple items of the same name" # do
   #    Item.destroy_all
   #    
   #    10.times do
   #      Item.create(:name => "Ubiquitous Item", :price => 3.14)
   #    end
   #    
   #    Item.all.count.should == 10
   #  end
  
  describe "automatic pricing" do
    # fixtures :members
    
    it "should calculate Torch of Holy Fire (Main Hand) price for Hunters" # do
     #      i = Item.create(:name => 'Torch of Holy Fire', :member => members(:sebudai))
     #      i.determine_item_price.should == 1.25
     #    end
    
    it "should calculate Torch of Holy Fire (Main Hand) price for non-Hunters" # do
     #      i = Item.create(:name => 'Torch of Holy Fire', :member => members(:tsigo))
     #      i.determine_item_price.should == 4.00
     #    end
  end
end
