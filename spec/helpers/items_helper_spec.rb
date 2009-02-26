require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ItemsHelper

describe ItemsHelper do
  before(:each) do
    Member.destroy_all
  end
  
  describe "item_tell_types" do
    it "should show comma-separated list of tell types" do
      item = Item.make(:best_in_slot => true, :rot => true)
      
      item_tell_types(item).should match (/Best in Slot<\/span>, .+Rot<\/span>$/)
    end
    
    it "should show Disenchanted for items without a buyer" do
      item = Item.make(:member => nil)
      
      item_tell_types(item).should == "<span class='item_de'>Disenchanted</span>"
    end
  end
  
  describe "item_row_classes" do
    it "should return multiple classes" do
      item = Item.make(:best_in_slot => true, :rot => true)
    
      item_row_classes(item).should == 'item_bis item_rot'
    end
  end
end
