require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Automator do
  before(:each) do
    @raid = Raid.make
    @raid.attendance_output = "Sebudai,1.00,233"
    @raid.loot_output = "Sebudai - [Arachnoid Gold Band]"
    
    @auto = Automator.new
  end
  
  describe "#items_from_attendance" do
    it "should return an array of items" do
      items = @auto.items_from_attendance(@raid.loot_output)
      
      items.size.should eql(1)
      items[0].class.should eql(Item)
    end
    
    it "should not save items automatically" do
      lambda { @auto.items_from_attendance(@raid.loot_output) }.
        should_not change(Item, :count)
    end
    
    # We enabled this for a while, then wimped out because there was no
    # distinguishing from a DE'd item and an item that had a misspelled buyer
    # it "should not save members automatically" do
    #   lambda { @auto.items_from_attendance(@raid.loot_output) }.
    #     should_not change(Member, :count)
    # end
    
    describe "item details" do
      before(:each) do
        item = 'Arachnoid Gold Band'
        @items = {
          :single       => @auto.items_from_attendance("Sebudai - #{item}"),
          :false_bis    => @auto.items_from_attendance("Sebisudai - #{item}"),
          :best_in_slot => @auto.items_from_attendance("Modrack (bis) - #{item}"),
          :rot          => @auto.items_from_attendance("Modrack (rot) - #{item}"),
          :sit          => @auto.items_from_attendance("Modrack (sit) - #{item}"),
          :bisrot       => @auto.items_from_attendance("Modrack (bis rot) - #{item}"),
          :multiple     => @auto.items_from_attendance("Modrack (bis), Rosoo (bis) - #{item}"),
          :de           => @auto.items_from_attendance("DE - #{item}"),
        }
        
        # items_from_attendance returns an array; each example only wants one item
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