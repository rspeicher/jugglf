require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemPrice do
  before(:all) do
    @ip = Juggy::ItemPrice.instance
  end
  
  it "should calculate Head prices" do
    @ip.price(:slot => 'Head', :level => 245).should eql(2.50)
  end

  it "should calculate Shoulder prices" do
    @ip.price(:slot => 'Shoulder', :level => 245).should eql(2.00)
  end

  it "should calculate Wrist prices" do
    @ip.price(:slot => 'Wrist', :level => 245).should eql(1.50)
  end

  it "should calculate Neck prices" do
    @ip.price(:slot => 'Neck', :level => 245).should eql(2.00)
  end

  it "should calculate Two-Hand prices" do
    @ip.price(:slot => 'Two-Hand', :level => 245).should eql(5.00)
    @ip.price(:slot => 'Two-Hand', :level => 245, :class => 'Hunter').should eql(2.00)
  end

  it "should calculate Main Hand prices" do
    @ip.price(:slot => 'Main Hand', :level => 245, :class => 'Priest').should eql(3.50)
    @ip.price(:slot => 'Main Hand', :level => 245, :class => 'Hunter').should eql(1.00)
  end

  it "should calculate One-Hand prices" do
    @ip.price(:slot => 'One-Hand', :level => 245, :class => 'Rogue').should eql(2.50)
    @ip.price(:slot => 'One-Hand', :level => 245, :class => 'Hunter').should eql(1.00)
  end

  it "should calculate Relic and Ranged prices" do
    @ip.price(:slot => 'Relic', :level => 245).should eql(1.00)
    @ip.price(:slot => 'Ranged', :level => 245, :class => 'Hunter').should eql(4.00)
  end

  it "should calculate Trinket prices" do
    @ip.price(:slot => 'Trinket', :name => 'Show of Faith', :level => 226).should eql(2.00)
    @ip.price(:slot => 'Trinket', :name => 'InvalidTrinket', :level => 245).should be_nil
  end
  
  it "should calculate 3.2 Trinket prices based on name AND level" do
    @ip.price(:slot => 'Trinket', :name => 'Solace of the Fallen', :level => 245).should eql(2.00)
    @ip.price(:slot => 'Trinket', :name => 'Solace of the Fallen', :level => 258).should eql(4.00)
  end
  
  it "should not raise an error when given a slot that doesn't exist" do
    options = {
    	:class => 'Rogue',
    	:slot  => 'Some Slot',
    	:item  => 'Some Item',
    	:level => 258
  	}

    lambda { @ip.price(:slot => 'Invalid', :level => 245) }.should_not raise_error(NoMethodError)
  end
  
  describe "special case items" do
    it "should calculate for Heroic Key to the Focusing Iris" do
      @ip.price(:name => 'Heroic Key to the Focusing Iris').should eql(1.00)
    end
    
    it "should calculate for Reply-Code Alpha" do
      @ip.price(:name => 'Reply-Code Alpha').should eql(1.00)
    end
    
    it "should calculate for Fragment of Val'anyr" do
      @ip.price(:name => "Fragment of Val'anyr", :level => 80).should eql(0.00)
    end
    
    it "should not return nil for older items" do
      @ip.price(:slot => "Two-Hand", :level => 158, :class => "Warlock").should eql(0.00)
    end
    
    describe "tier tokens" do
      it "should calculate for Breastplate" do
        @ip.price(:name => 'Breastplate of the Wayward Conqueror', :level => 80).should eql(1.50)
      end
      
      it "should calculate for Crown" do
        @ip.price(:name => 'Crown of the Wayward Conqueror', :level => 80).should eql(1.50)
      end
      
      it "should calculate for Gauntlets" do
        @ip.price(:name => 'Gauntlets of the Wayward Conqueror', :level => 80).should eql(1.00)
      end
      
      it "should calculate for Legplates" do
        @ip.price(:name => 'Legplates of the Wayward Conqueror', :level => 80).should eql(1.50)
      end
      
      it "should calculate for Mantle" do
        @ip.price(:name => 'Mantle of the Wayward Conqueror', :level => 80).should eql(1.00)
      end
      
      it "should calculate for Lost" do
        @ip.price(:name => 'Mantle of the Lost Vanquisher', :level => 80).should eql(0.00)
      end
      
      it "should calculate for Wayward" do
        @ip.price(:name => 'Mantle of the Wayward Vanquisher', :level => 80).should eql(1.00)
      end
      
      it "should calculate for Regalia of the Grand" do
        @ip.price(:name => 'Regalia of the Grand Conqueror', :level => 80).should eql(3.00)
      end
      
      it "should calculate for Trophy of the Crusade" do
        @ip.price(:name => 'Trophy of the Crusade', :level => 80).should eql(2.50)
      end
    end
  end
end

describe ItemPrice, "weapon special cases" do
  before(:each) do
    @ip = Juggy::ItemPrice.instance
  end
  
  describe "for Death Knights" do
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'Off Hand', :level => 245, :class => 'Death Knight').should eql(2.50)
    end
  end
  
  describe "for Hunters" do
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'Main Hand', :level => 245, :class => 'Hunter').should eql(1.00)
      @ip.price(:slot => 'Ranged', :level => 245, :class => 'Hunter').should eql(4.00)
    end
  end
  
  describe "for Rogues" do
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'One-Hand', :level => 245, :class => 'Rogue').should eql(2.50)
      @ip.price(:slot => 'Thrown', :level => 245, :class => 'Rogue').should eql(1.00)
    end
  end
  
  describe "for Shaman" do
    it "should calculate Shield price" do
      @ip.price(:slot => 'Shield', :level => 245, :class => 'Shaman').should eql(1.50)
    end
  
    it "should calculate One-Hand price" do
      @ip.price(:slot => 'One-Hand', :level => 245, :class => 'Shaman').should eql(2.50)
    end
  
    it "should calculate every other slot price" do
      @ip.price(:slot => 'Main Hand', :level => 245, :class => 'Shaman').should eql(3.50)
    end
  end
  
  describe "for Warriors" do
    it "should calculate Shield price" do
      @ip.price(:slot => 'Shield', :level => 245, :class => 'Warrior').should eql(2.50)
    end
    
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'Off Hand', :level => 245, :class => 'Warrior').should eql(2.50)
    end
  end
  
  describe "for other classes" do
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'Main Hand', :level => 245, :class => 'Priest').should eql(3.50)
    end
  end
end