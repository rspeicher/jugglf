require 'spec_helper'

describe ItemPrice do
  before(:all) do
    @ip = Juggy::ItemPrice.instance
  end

  it "should calculate Head prices" do
    @ip.price(:slot => 'Head', :level => 264).should eql(2.50)
  end

  it "should calculate Shoulder prices" do
    @ip.price(:slot => 'Shoulder', :level => 264).should eql(2.00)
  end

  it "should calculate Wrist prices" do
    @ip.price(:slot => 'Wrist', :level => 264).should eql(1.50)
  end

  it "should calculate Neck prices" do
    @ip.price(:slot => 'Neck', :level => 264).should eql(1.50)
  end

  it "should calculate Back prices" do
    @ip.price(:slot => 'Back', :level => 277).should eql(0.50)
  end

  it "should calculate Two-Hand prices" do
    @ip.price(:slot => 'Two-Hand', :level => 264).should eql(5.00)
    @ip.price(:slot => 'Two-Hand', :level => 264, :class => 'Hunter').should eql(2.00)
  end

  it "should calculate Main Hand prices" do
    @ip.price(:slot => 'Main Hand', :level => 264, :class => 'Priest').should eql(3.50)
    @ip.price(:slot => 'Main Hand', :level => 264, :class => 'Hunter').should eql(1.00)
  end

  it "should calculate One-Hand prices" do
    @ip.price(:slot => 'One-Hand', :level => 264, :class => 'Rogue').should eql(2.50)
    @ip.price(:slot => 'One-Hand', :level => 264, :class => 'Hunter').should eql(1.00)
  end

  it "should calculate Relic and Ranged prices" do
    @ip.price(:slot => 'Relic', :level => 264).should eql(1.00)
    @ip.price(:slot => 'Ranged', :level => 264, :class => 'Hunter').should eql(4.00)
  end

  it "should calculate Trinket prices" do
    @ip.price(:slot => 'Trinket', :name => 'Show of Faith', :level => 226).should eql(1.00)
    @ip.price(:slot => 'Trinket', :name => 'InvalidTrinket', :level => 264).should be_nil
  end

  it "should calculate 3.2 Trinket prices based on name AND level" do
    @ip.price(:slot => 'Trinket', :name => 'Solace of the Fallen', :level => 245).should eql(2.00)
    @ip.price(:slot => 'Trinket', :name => 'Solace of the Fallen', :level => 258).should eql(4.00)
  end

  it "should calculate 3.3 Trinket prices based on name AND level" do
    @ip.price(:slot => 'Trinket', :name => 'Tiny Abomination in a Jar', :level => 264).should eql(2.00)
    @ip.price(:slot => 'Trinket', :name => 'Tiny Abomination in a Jar', :level => 277).should eql(4.00)
  end

  it "should not raise an error when given a slot that doesn't exist" do
    lambda { @ip.price(:slot => 'Invalid', :level => 264) }.should_not raise_error(NoMethodError)
  end

  context "special case items" do
    it "should calculate for Heroic Key to the Focusing Iris" do
      @ip.price(:name => 'Heroic Key to the Focusing Iris').should eql(0.00)
    end

    it "should calculate for Reply-Code Alpha" do
      @ip.price(:name => 'Reply-Code Alpha').should eql(0.00)
    end

    it "should calculate for Fragment of Val'anyr" do
      @ip.price(:name => "Fragment of Val'anyr", :level => 80).should eql(0.00)
    end

    it "should not return nil for older items" do
      @ip.price(:slot => "Two-Hand", :level => 158, :class => "Warlock").should eql(0.00)
    end
  end

  context "tier tokens" do
    it "should calculate for Breastplate" do
      @ip.price(:name => 'Breastplate of the Wayward Conqueror', :level => 80).should eql(0.50)
    end

    it "should calculate for Crown" do
      @ip.price(:name => 'Crown of the Wayward Conqueror', :level => 80).should eql(0.50)
    end

    it "should calculate for Gauntlets" do
      @ip.price(:name => 'Gauntlets of the Wayward Conqueror', :level => 80).should eql(0.00)
    end

    it "should calculate for Legplates" do
      @ip.price(:name => 'Legplates of the Wayward Conqueror', :level => 80).should eql(0.50)
    end

    it "should calculate for Mantle" do
      @ip.price(:name => 'Mantle of the Wayward Conqueror', :level => 80).should eql(0.00)
    end

    it "should calculate for Lost" do
      @ip.price(:name => 'Mantle of the Lost Vanquisher', :level => 80).should eql(0.00)
    end

    it "should calculate for Wayward" do
      @ip.price(:name => 'Mantle of the Wayward Vanquisher', :level => 80).should eql(0.00)
    end

    it "should calculate for Regalia of the Grand" do
      @ip.price(:name => 'Regalia of the Grand Conqueror', :level => 80).should eql(2.00)
    end

    it "should calculate for Trophy of the Crusade" do
      @ip.price(:name => 'Trophy of the Crusade', :level => 80).should eql(1.50)
    end

    it "should calculate for Conqueror's Mark of Sanctification (Normal)" do
      @ip.price(:name => 'Not Used', :level => 80, :id => 52027).should eql(2.50)
    end

    it "should calculate for Conqueror's Mark of Sanctification (Heroic)" do
      @ip.price(:name => 'Not Used', :level => 80, :id => 52030).should eql(3.00)
    end
  end
end

describe ItemPrice, "weapon special cases" do
  before(:each) do
    @ip = Juggy::ItemPrice.instance
  end

  context "for Death Knights" do
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'Off Hand', :level => 264, :class => 'Death Knight').should eql(2.50)
    end
  end

  context "for Hunters" do
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'Main Hand', :level => 264, :class => 'Hunter').should eql(1.00)
      @ip.price(:slot => 'Ranged', :level => 264, :class => 'Hunter').should eql(4.00)
    end
  end

  context "for Rogues" do
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'One-Hand', :level => 264, :class => 'Rogue').should eql(2.50)
      @ip.price(:slot => 'Thrown', :level => 264, :class => 'Rogue').should eql(1.00)
    end
  end

  context "for Shaman" do
    it "should calculate Shield price" do
      @ip.price(:slot => 'Shield', :level => 264, :class => 'Shaman').should eql(1.50)
    end

    it "should calculate One-Hand price" do
      @ip.price(:slot => 'One-Hand', :level => 264, :class => 'Shaman').should eql(2.50)
    end

    it "should calculate every other slot price" do
      @ip.price(:slot => 'Main Hand', :level => 264, :class => 'Shaman').should eql(3.50)
    end
  end

  context "for Warriors" do
    it "should calculate Shield price" do
      @ip.price(:slot => 'Shield', :level => 264, :class => 'Warrior').should eql(2.50)
    end

    it "should calculate all weapon prices" do
      @ip.price(:slot => 'Off Hand', :level => 264, :class => 'Warrior').should eql(2.50)
    end
  end

  context "for other classes" do
    it "should calculate all weapon prices" do
      @ip.price(:slot => 'Main Hand', :level => 264, :class => 'Priest').should eql(3.50)
    end
  end
end