# == Schema Information
#
# Table name: loots
#
#  id           :integer(4)      not null, primary key
#  item_id      :integer(4)
#  price        :float
#  purchased_on :date
#  best_in_slot :boolean(1)
#  situational  :boolean(1)
#  rot          :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Loot do
  before(:each) do
    @member = Member.make(:name => 'Member')
    @loot = Loot.make(:item => Item.make(:name => 'Item'), 
      :member => @member)
  end
  
  it "should be valid" do
    @loot.should be_valid
  end
  
  it "should return the correct adjusted price for rot loots" do
    @loot.adjusted_price.should eql(1.00)
    
    @loot.rot = true
    @loot.adjusted_price.should eql(0.50)
  end
  
  it "should know whether or not it affects loot factor" do
    @loot.affects_loot_factor?.should be_true
    
    @loot.purchased_on = 1.year.ago
    @loot.affects_loot_factor?.should be_false
  end
  
  describe "#has_purchase_type?" do
    before(:each) do
      @loot = Loot.make
    end
    
    it "should return nil for bogus types" do
      @loot.has_purchase_type?('bogus').should be_nil
    end
    
    it "should know :best_in_slot?" do
      @loot.best_in_slot = true
      @loot.has_purchase_type?(:best_in_slot).should be_true
    end
    
    it "should know :situational?" do
      @loot.situational = true
      @loot.has_purchase_type?(:situational).should be_true
    end
    
    it "should know :rot?" do
      @loot.has_purchase_type?(:rot).should be_false
    end
    
    it "should know :normal?" do
      @loot.has_purchase_type?('NORMAL?').should be_true
    end
  end
  
  describe "#update_cache" do
    before(:each) do
      @loot.price = 15.0
      @member.update_attributes(:lf => 1.00)
    end
    
    it "should update buyer cache unless disabled" do
      @loot.update_cache = true
      
      lambda do
        @loot.save
        @member.reload
      end.should change(@member, :lf).to(1500.00)
    end
    
    it "should allow disabling of buyer cache updates" do
      @loot.update_cache = false
      
      lambda do
        @loot.save
        @member.reload
      end.should_not change(@member, :lf)
    end
  end
  
  describe "#set_purchased_on" do
    it "should set purchased_on" do
      @loot.purchased_on = nil
      
      lambda { @loot.save }.should change(@loot, :purchased_on).to(Date.today)
    end
  end
  
  describe "#item_name" do
    it "should return wow_id if present" do
      @loot.item_name.should eql(@loot.item.wow_id)
    end
    
    it "should return item's name wow_id is nil" do
      @loot.item.wow_id = nil
      @loot.item_name.should eql(@loot.item.name)
    end
    
    it "should otherwise return nil" do
      @loot.item_id = nil
      @loot.item_name.should be_nil
    end
    
    it "should assign item from string" do
      item = Item.make(:name => 'New Item')
      @loot.item_name = 'New Item'
      @loot.item.should eql(item)
    end
  end
  
  describe "#member_name" do
    it "should return member's name if not nil" do
      @loot.member_name.should eql('Member')
    end
    
    it "should return nil if member_id is nil" do
      @loot.member_id = nil
      @loot.member_name.should be_nil
    end
    
    it "should assign member from string" do
      member = Member.make(:name => 'NewMember')
      @loot.member_name = 'NewMember'
      @loot.member.should eql(member)
    end
  end
end
