require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Loot do
  before(:each) do
    @loot = Loot.make
  end
  
  it "should be valid" do
    @loot.should be_valid
  end
  
  it "should return the correct adjusted price for rot loots" do
    @loot.adjusted_price.should == 1.00
    
    @loot.rot = true
    @loot.adjusted_price.should == 0.50
  end
  
  it "should know whether or not it affects loot factor" do
    @loot.affects_loot_factor?.should be_true
    
    @loot.purchased_on = 1.year.ago
    @loot.affects_loot_factor?.should be_false
  end
end
