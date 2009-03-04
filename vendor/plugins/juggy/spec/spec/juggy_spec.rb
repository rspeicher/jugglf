require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Juggy do
  before(:each) do
    ItemStat.destroy_all
    
    @attendance_output = "Sebudai,1.00,233"
    @loot_output = "Sebudai - [Arachnoid Gold Band]"
  end
  
  describe "#parse_loots" do
    before(:each) do
      # Juggy.parse_loots tries to figure out the price via ItemStat's
      # data; fake that so we don't hit Wowhead for non-existant items
      ItemStat.stub!(:lookup).and_return(ItemStat.make)
    end
    
    it "should return an array of hashes" do
      loots = Juggy.parse_loots(@loot_output)
      
      loots.size.should eql(1)
      loots[0].class.should eql(Hash)
    end
    
    it "should not save loots automatically" do
      lambda { Juggy.parse_loots(@loot_output) }.
        should_not change(Loot, :count)
    end
    
    # We enabled this for a while, then wimped out because there was no
    # distinguishing from a DE'd item and an item that had a misspelled buyer
    # it "should not save members automatically" do
    #   lambda { Juggy.parse_loots(@loot_output) }.
    #     should_not change(Member, :count)
    # end
    
    describe "automatic pricing" do
      it "should figure out price based on item stats" do
        loots = Juggy.parse_loots('Buyer - Item')
        
        loots[0][:price].should == 3.00
      end
    end
    
    describe "loot details" do
      before(:all) do
        item = 'Arachnoid Gold Band'
        @loots = {
          :single       => Juggy.parse_loots("Sebudai - #{item}"),
          :false_bis    => Juggy.parse_loots("Sebisudai - #{item}"),
          :best_in_slot => Juggy.parse_loots("Modrack (bis) - #{item}"),
          :rot          => Juggy.parse_loots("Modrack (rot) - #{item}"),
          :sit          => Juggy.parse_loots("Modrack (sit) - #{item}"),
          :bisrot       => Juggy.parse_loots("Modrack (bis rot) - #{item}"),
          :multiple     => Juggy.parse_loots("Modrack (bis), Rosoo (sit), DE - #{item}"),
          :de           => Juggy.parse_loots("DE - #{item}"),
        }
        
        # parse_items returns an array; each example only wants one item
        @loots.each { |k, v| @loots[k] = v[0] unless k == :multiple }
      end
    
      it "should return one Hash" do
        @loots[:single].class.should == Hash
      end
    
      it "should correctly set best_in_slot" do
        @loots[:best_in_slot][:best_in_slot].should be_true
      end
    
      it "should correctly set situational" do
        @loots[:sit][:situational].should be_true
      end
    
      it "should correctly set rot" do
        @loots[:rot][:rot].should be_true
      end
    
      it "should correctly set best_in_slot and rot at the same time" do
        @loots[:bisrot][:best_in_slot].should be_true
        @loots[:bisrot][:rot].should be_true
      end
    
      it "should not have false positives for purchase types inside buyer names" do
        @loots[:false_bis][:best_in_slot].should be_false
      end
    
      it "should set member as nil if buyer is 'DE'" do
        @loots[:de][:member].should be_nil
      end
      
      describe "for multiple buyers" do
        it "should get the correct number of buyers" do
          @loots[:multiple].size.should == 3
        end
        
        it "should get the correct buyer names" do
          @loots[:multiple][0][:member].name.should == 'Modrack'
          @loots[:multiple][1][:member].name.should == 'Rosoo'
          @loots[:multiple][2][:member].should be_nil
        end
        
        it "should get the correct item types" do
          @loots[:multiple][0][:best_in_slot].should be_true
          @loots[:multiple][1][:situational].should be_true
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