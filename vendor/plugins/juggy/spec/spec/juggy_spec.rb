require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juggy do
  before(:each) do
    Item.destroy_all
    
    @attendance_output = "Sebudai,1.00,233"
    @loot_output = "Sebudai - [Arachnoid Gold Band]"
  end
  
  describe "#parse_loots" do
    it "should return an array of hashes" do
      loots = Juggy.parse_loots(@loot_output)
      
      loots.size.should eql(1)
      loots[0].class.should eql(Hash)
    end
    
    it "should not save loots automatically" do
      lambda { Juggy.parse_loots(@loot_output) }.
        should_not change(Loot, :count)
    end
    
    it "should figure out price based on item stats" do
      # Juggy.parse_loots tries to figure out the price via Item's
      # data; fake that so we don't hit Wowhead for non-existant items
      Item.stub!(:find_or_initialize_by_name).and_return(Item.make)
      
      loots = Juggy.parse_loots('Buyer - Item')
      loots[0][:price].should == 3.00 # Price for a 258 Head slot
    end
    
    describe "multiple items of the same name" do
      it "should create a non-existent item if given the ID" do
        Item.destroy_all
        old_item = Item.make(:old_onyxia_head)
        new_item = Item.make_unsaved(:new_onyxia_head)
        loots = Juggy.parse_loots("Tsigo - [#{new_item.name}]|#{new_item.wow_id}")
        loots[0][:item].inspect.should eql(new_item.inspect)
      end
    end
    
    describe "loot details" do
      before(:each) do
        @item = Item.make(:with_real_stats)
      end
    
      it "should return one Hash" do
        loot = Juggy.parse_loots("Sebudai - #{@item.name}")
        loot[0].class.should == Hash
      end
    
      it "should correctly set best_in_slot" do
        loot = Juggy.parse_loots("Modrack (bis) - #{@item.name}")
        loot[0][:best_in_slot].should be_true
      end
    
      it "should correctly set situational" do
        loot = Juggy.parse_loots("Modrack (sit) - #{@item.name}")
        loot[0][:situational].should be_true
      end
    
      it "should correctly set rot" do
        loot = Juggy.parse_loots("Modrack (rot) - #{@item.name}")
        loot[0][:rot].should be_true
      end
    
      it "should correctly set best_in_slot and rot at the same time" do
        loot = Juggy.parse_loots("Modrack (bis rot) - #{@item.name}")
        loot[0][:best_in_slot].should be_true
        loot[0][:rot].should be_true
      end
    
      it "should not have false positives for purchase types inside buyer names" do
        loot = Juggy.parse_loots("Sebisudai - #{@item.name}")
        loot[0][:best_in_slot].should be_false
      end
    
      it "should set member as nil if buyer is 'DE'" do
        loot = Juggy.parse_loots("DE - #{@item.name}")
        loot[0][:member].should be_nil
      end
      
      it "should use the wow_id if provided" do
        Item.destroy_all
        glaive_main = Item.make(:name => 'Warglaive of Azzinoth', :wow_id => 32837)
        glaive_off  = Item.make(:name => 'Warglaive of Azzinoth', :wow_id => 32838)
        loot = Juggy.parse_loots("Kamien (bis) - [Ignore Me]|32838")
        loot[0][:item].should eql(glaive_off)
      end

      # TODO: Couldn't get the regex figured out
      # it "should not require parenthesis around the loot type" do
      #   @loots[:no_parens][:best_in_slot].should be_true
      #   @loots[:no_parens][:member].name.should eql('Kamien')
      # end
      
      describe "for multiple buyers" do
        before(:each) do
          @loot = Juggy.parse_loots("Modrack (bis), Rosoo (sit), DE - #{@item.name}")
        end
        
        it "should get the correct number of buyers" do
          @loot.size.should == 3
        end
        
        it "should get the correct buyer names" do
          @loot[0][:member].name.should == 'Modrack'
          @loot[1][:member].name.should == 'Rosoo'
          @loot[2][:member].should be_nil
        end
        
        it "should get the correct item types" do
          @loot[0][:best_in_slot].should be_true
          @loot[1][:situational].should be_true
        end
      end
    end
  end
  
  describe "#parse_attendees" do
    before(:each) do
      @att = Juggy.parse_attendees(@attendance_output)
    end
    
    it "should return an array of hashes" do
      @att.size.should eql(1)
      @att[0].class.should eql(Hash)
    end
    
    it "should return duplicate members when provided" do
      output = ''
      3.times { output += @attendance_output + "\n" }
      @att = Juggy.parse_attendees(output)
      
      @att.size.should == 3
    end
  end
end