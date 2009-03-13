# == Schema Information
# Schema version: 20090312150316
#
# Table name: mgdkp_items
#
#  item_id          :integer(3)      not null, primary key
#  item_name        :string(255)
#  item_buyer       :string(50)
#  raid_id          :integer(4)      default(0), not null
#  item_value       :float(11)       default(0.0), not null
#  item_date        :integer(4)      default(0), not null
#  item_added_by    :string(30)      default(""), not null
#  item_updated_by  :string(30)
#  item_group_key   :string(32)
#  item_situational :boolean(1)      not null
#  item_bis         :boolean(1)      not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyItem do
  before(:each) do
    @params = {
      :item_name        => 'Name',
      :item_buyer       => Member.make.name,
      :raid_id          => Raid.make,
      :item_value       => 3.14,
      :item_date        => 1235453198,
      :item_situational => 1,
      :item_bis         => 0,
    }

    @legacy = LegacyItem.create(@params)
  end
  
  it "should return item_name" do
    @legacy.name.should == @params[:item_name]
  end
  
  it "should return item_price" do
    @legacy.price.should == @params[:item_value]
  end
  
  it "should return item_situational" do
    @legacy.situational.should be_true
    @legacy.situational?.should be_true
  end
  
  it "should return item_bis" do    
    @legacy.best_in_slot.should be_false
    @legacy.best_in_slot?.should be_false
  end
  
  it "should know if an item is priced as rot" do
    @legacy.item_value = 0.50
    @legacy.price.should == 0.50
    @legacy.rot?.should be_true
  end
  
  describe "item_buyer" do
    it "should return nil if 'Juggernaut'" do
      @legacy.item_buyer = 'Juggernaut'
      @legacy.member_id.should be_nil
    end
    
    it "should raise an error if a buyer wasn't found" do
      @legacy.item_buyer = 'InvalidMember'
      
      lambda { @legacy.member_id }.should raise_error
    end
    
    it "should return a member ID" do
      @legacy.member_id.should == Member.find(:last).id
    end
  end
end
