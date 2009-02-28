require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Loot do
  before(:each) do
    @loot = Loot.make
  end
  
  it "should be valid" do
    @loot.should be_valid
  end
end
