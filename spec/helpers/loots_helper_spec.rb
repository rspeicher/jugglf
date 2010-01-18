require 'spec_helper'

include LootsHelper

describe "loot_tell_types" do
  it "should list multiple tell types" do
    loot = Factory(:loot_with_buyer, :best_in_slot => true, :rot => true)
    
    loot_tell_types(loot).should match(/Best in Slot.+Rot/)
  end
  
  it "should show Disenchanted for loots without a buyer" do
    loot = Factory(:loot)
    
    loot_tell_types(loot).should match(/Disenchanted/)
  end
  
  it "should show 'Normal' for loots without a tell type" do
    loot = Factory(:loot_with_buyer)
    
    loot_tell_types(loot).should match(/Normal/)
  end  
end

describe "loot_row_classes" do
  it "should return multiple classes" do
    loot = Factory(:loot_with_buyer, :best_in_slot => true, :rot => true)
  
    loot_row_classes(loot).should eql('loot_bis loot_rot')
  end
  
  it "should return 'loot_normal' for loots without a tell type" do
    loot = Factory(:loot_with_buyer)
    
    loot_row_classes(loot).should eql('loot_normal')
  end
end

describe "loot_factor_cutoff" do
  before(:each) do
    Timecop.freeze(Date.today)
    @future = 1.month.since(Date.today)
    @past   = 5.months.until(Date.today)
  end
  
  it "should display relative date for future" do
    loot_factor_cutoff(@future).should eql('2 months from today')
  end
  
  it "should display relative date for past" do
    loot_factor_cutoff(@past).should eql('3 months ago')
  end
  
  it "should display 'Today' for current date" do
    loot_factor_cutoff(52.days.until(Date.today)).should eql('Today')
  end
end
