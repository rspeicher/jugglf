require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemPrice do
  before(:all) do
    @ip = Juggy::ItemPrice.new
  end
  
  it "should calculate Soul of the Dead (Trinket) price" do
    @ip.price(ItemStat.make(:trinket), false).should == 4.00
  end
  
  it "should calculate Torch of Holy Fire (Main Hand) price for Hunters" # do
   #    @ip.price(ItemStat.make(:mainhand), true).should == 1.25
   #  end
  
  it "should calculate Torch of Holy Fire (Main Hand) price for non-Hunters" # do
   #    @ip.price(ItemStat.make(:mainhand), false).should == 4.00
   #  end
  
  it "should calculate Betrayer of Humanity (Two-Hand) price for Hunters" # do
   #    @ip.price(ItemStat.make(:twohand), true).should == 2.50
   #  end
  
  it "should calculate Betrayer of Humanity (Two-Hand) price for non-Hunters" # do
   #    @ip.price(ItemStat.make(:twohand), false).should == 6.00
   #  end
  
  it "should calculate Sinister Revenge (One-Hand) price for Hunters" # do
   #    @ip.price(ItemStat.make(:onehand), true).should == 1.25
   #  end
  
  it "should calculate Sinister Revenge (One-Hand) price for non-Hunters" # do
   #    @ip.price(ItemStat.make(:onehand), false).should == [4.00, 2.00]
   #  end
  
  it "should calculate Heroic Key to the Focusing Iris (Neck Turn-in) price" # do
   #    @ip.price(ItemStat.make(:quest_item)).should == 2.50
   #  end
  
  it "should calculate Breastplate of the Lost Conqueror (Chest Token) price" # do
   #    @ip.price(ItemStat.make(:chest_token)).should == 2.50
   #  end
  
  it "should raise an exception for an invalid slot name" # do
   #    stat = ItemStat.make(:trinket)
   #    stat.slot = 'Not a Real Slot'
   #    
   #    lambda { @ip.price(stat) }.should raise_error
   #  end
  
  it "should raise an exception for an invalid trinket name" # do
   #    stat = ItemStat.make(:trinket)
   #    stat.item = 'Not a Real Trinket'
   #    
   #    lambda { @ip.price(stat) }.should raise_error
   #  end
  
  it "should handle a nil ItemStat object" do
    lambda { @ip.price(nil, nil) }.should_not raise_error
  end
end