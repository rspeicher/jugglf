require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juggy do
  before(:each) do
    @attendance_output = "Sebudai,1.00,233"
    @loot_output = "Sebudai - [Arachnoid Gold Band]"
  end
  
  describe "#parse_items" do
    it "should return an array of items" do
      items = Juggy.parse_items(@loot_output)
      
      items.size.should eql(1)
      items[0].class.should eql(Item)
    end
    
    it "should not save items automatically" do
      lambda { Juggy.parse_items(@loot_output) }.
        should_not change(Item, :count)
    end
    
    # We enabled this for a while, then wimped out because there was no
    # distinguishing from a DE'd item and an item that had a misspelled buyer
    # it "should not save members automatically" do
    #   lambda { Juggy.parse_items(@loot_output) }.
    #     should_not change(Member, :count)
    # end
    
    describe "automatic pricing" do
      before(:each) do
        # Juggy.parse_items tries to figure out the price via ItemStat's
        # data; fake that so we don't hit Wowhead for non-existant items
        ItemStat.stub!(:lookup).and_return(ItemStat.make)
      end
      
      it "should figure out price based on item stats" do
        items = Juggy.parse_items('Buyer - Item')
        
        items[0].price.should == 3.00
      end
    end
    
    describe "item details" do
      before(:each) do
        item = 'Arachnoid Gold Band'
        @items = {
          :single       => Juggy.parse_items("Sebudai - #{item}"),
          :false_bis    => Juggy.parse_items("Sebisudai - #{item}"),
          :best_in_slot => Juggy.parse_items("Modrack (bis) - #{item}"),
          :rot          => Juggy.parse_items("Modrack (rot) - #{item}"),
          :sit          => Juggy.parse_items("Modrack (sit) - #{item}"),
          :bisrot       => Juggy.parse_items("Modrack (bis rot) - #{item}"),
          :multiple     => Juggy.parse_items("Modrack (bis), Rosoo (bis) - #{item}"),
          :de           => Juggy.parse_items("DE - #{item}"),
        }
        
        # parse_items returns an array; each example only wants one item
        @items.each { |k, v| @items[k] = v[0] }
      end
    
      it "should return one Item" do
        @items[:single].class.should == Item
      end
    
      it "should correctly set best_in_slot" do
        @items[:best_in_slot].best_in_slot?.should be_true
      end
    
      it "should correctly set situational" do
        @items[:sit].situational?.should be_true
      end
    
      it "should correctly set rot" do
        @items[:rot].rot?.should be_true
      end
    
      it "should correctly set best_in_slot and rot at the same time" do
        @items[:bisrot].best_in_slot?.should be_true
        @items[:bisrot].rot?.should be_true
      end
    
      it "should not have false positives for purchase types inside buyer names" do
        @items[:false_bis].best_in_slot?.should be_false
      end
    
      it "should set member as nil if buyer is 'DE'" do
        @items[:de].member.should be_nil
      end
    end
  end
  
  describe "output from JuggyAttendance" do
    it "should return an array of attendees"
  end
end