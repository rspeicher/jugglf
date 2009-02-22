require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Automator do
  before(:each) do
    @raid = Raid.make
    @raid.attendance_output = "Sebudai,1.00,233"
    @raid.loot_output = "Sebudai - [Arachnoid Gold Band]"
    
    @ja = Automator.new
  end
  
  describe "#items_from_attendance" do
    it "should return an array of items" do
      items = @ja.items_from_attendance(@raid.loot_output)
      
      items.size.should eql(1)
      items[0].class.should eql(Item)
    end
    
    it "should not save items automatically" do
      lambda { @ja.items_from_attendance(@raid.loot_output) }.
        should_not change(Item, :count)
    end
    
    # it "should not save members automatically" do
    #   lambda { @ja.items_from_attendance(@raid.loot_output) }.
    #     should_not change(Member, :count)
    # end
  end
  
  describe "#item_from_attendance_line" do
    # This method is private
    # before(:all) do
    #   auto = Automator.new
    #   item = 'Arachnoid Gold Band'
    #   @items = {
    #     :single       => auto.item_from_attendance_line("Sebudai", item),
    #     :false_bis    => auto.item_from_attendance_line("Sebisudai", item),
    #     :best_in_slot => auto.item_from_attendance_line("Modrack (bis)", item),
    #     :rot          => auto.item_from_attendance_line("Modrack (rot)", item),
    #     :sit          => auto.item_from_attendance_line("Modrack (sit)", item),
    #     :bisrot       => auto.item_from_attendance_line("Modrack (bis rot)", item),
    #     # :multiple     => auto.item_from_attendance_line("Modrack (bis), Rosoo (bis)", item),
    #     :de           => auto.item_from_attendance_line('DE', item)
    #   }
    # end
    # 
    # it "should return one Item" do
    #   @items[:single].class.should == Item
    # end
    # 
    # it "should correctly set best_in_slot" do
    #   @items[:best_in_slot].best_in_slot?.should be_true
    # end
    # 
    # it "should correctly set situational" do
    #   @items[:sit].situational?.should be_true
    # end
    # 
    # it "should correclty set rot" do
    #   @items[:rot].rot?.should be_true
    # end
    # 
    # it "should correclty set best_in_slot and rot at the same time" do
    #   @items[:bisrot].best_in_slot?.should be_true
    #   @items[:bisrot].rot?.should be_true
    # end
    # 
    # it "should not have false positives for purchase types inside buyer names" do
    #   @items[:false_bis].best_in_slot?.should be_false
    # end
    # 
    # it "should set member as nil if buyer is 'DE'" do
    #   @items[:de].member.should be_nil
    # end
  end
  
  describe "output from JuggyAttendance" do
    it "should return an array of attendees"
  end
end