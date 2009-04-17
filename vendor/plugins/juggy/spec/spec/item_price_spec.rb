require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemPrice do
  before(:all) do
    @ip = Juggy::ItemPrice.instance
  end
  
  describe "from Naxxramas" do
    it "should calculate Head prices" do
      @ip.price(:slot => 'Head', :level => 213).should == 2.50
    end
  
    it "should calculate Shoulder prices" do
      @ip.price(:slot => 'Shoulder', :level => 213).should == 2.00
    end
  
    it "should calculate Wrist prices" do
      @ip.price(:slot => 'Wrist', :level => 213).should == 1.50
    end
  
    it "should calculate Neck prices" do
      @ip.price(:slot => 'Neck', :level => 213).should == 2.00
    end
  
    it "should calculate Two-Hand prices" do
      @ip.price(:slot => 'Two-Hand', :level => 213).should == 5.00
      @ip.price(:slot => 'Two-Hand', :level => 213, :class => 'Hunter').should == 2.00
    end
  
    it "should calculate Main Hand prices" do
      @ip.price(:slot => 'Main Hand', :level => 226, :class => 'Priest').should == 4.00
      @ip.price(:slot => 'Main Hand', :level => 226, :class => 'Hunter').should == 1.25
    end
  
    it "should calculate One-Hand prices" do
      @ip.price(:slot => 'One-Hand', :level => 213, :class => 'Rogue').should == 2.50
      @ip.price(:slot => 'One-Hand', :level => 213, :class => 'Hunter').should == 1.00
    end
  
    it "should calculate Relic and Ranged prices" do
      @ip.price(:slot => 'Relic', :level => 213).should == 1.00
      @ip.price(:slot => 'Ranged', :level => 213, :class => 'Hunter').should == 4.00
    end
  
    it "should calculate Trinket prices" do
      @ip.price(:slot => 'Trinket', :name => 'Soul of the Dead', :level => 213).should == 4.00
      @ip.price(:slot => 'Trinket', :name => 'InvalidTrinket', :level => 213).should be_nil
    end
  
    it "should calculate for special case items" do
      @ip.price(:name => 'Heroic Key to the Focusing Iris').should == 2.50
      @ip.price(:name => 'Breastplate of the Lost Conqueror', :level => 80).should == 2.50
    end
  end
end