require 'spec_helper'

describe ItemPrice do
  before(:all) do
    @ip = ItemPrice.instance
  end

  # Set this to a variable because it gets updated as we progress through content,
  # but the prices should stay consistent.
  let(:median_level) { 264 }

  it "should validate keys" do
    lambda { @ip.price(:invalid => 'Something', :id => 12345) }.should raise_error(ArgumentError)
  end

  it "should not raise an error when given a slot that doesn't exist" do
    lambda { @ip.price(:slot => 'Invalid', :level => 264) }.should_not raise_error(NoMethodError)
  end

  context "legendary tokens" do
    it "should price Shadowfrost Shard" do
      @ip.price(:name => 'Shadowfrost Shard', :level => 80).should eql(0.20)
    end

    it "should price Fragment of Val'anyr" do
      @ip.price(:name => "Fragment of Val'anyr", :level => 80).should eql(0.00)
    end
  end

  context "generic slot prices" do
    slots = [['Head', 2.50], ['Shoulder', 2.00], ['Wrist', 1.50], ['Neck', 1.50], ['Back', 0.50]]

    slots.each do |slot, value|
      it "should calculate for #{slot}" do
        @ip.price(:slot => slot, :level => median_level).should eql(value)
      end
    end
  end

  context "special weapon slot prices" do
    it "should calculate Two-Hand prices" do
      @ip.price(:slot => 'Two-Hand', :level => median_level).should eql(5.00)
      @ip.price(:slot => 'Two-Hand', :level => median_level, :class => 'Hunter').should eql(2.00)
    end

    it "should calculate Main Hand prices" do
      @ip.price(:slot => 'Main Hand', :level => median_level, :class => 'Priest').should eql(3.50)
      @ip.price(:slot => 'Main Hand', :level => median_level, :class => 'Hunter').should eql(1.00)
    end

    it "should calculate One-Hand prices" do
      @ip.price(:slot => 'One-Hand', :level => median_level, :class => 'Rogue').should eql(2.50)
      @ip.price(:slot => 'One-Hand', :level => median_level, :class => 'Hunter').should eql(1.00)
    end

    it "should calculate Relic and Ranged prices" do
      @ip.price(:slot => 'Relic',  :level => median_level).should eql(1.00)
      @ip.price(:slot => 'Ranged', :level => median_level, :class => 'Hunter').should eql(4.00)
    end

    it "should calculate all weapon prices for Death Knights" do
      @ip.price(:slot => 'Off Hand', :level => median_level, :class => 'Death Knight').should eql(2.50)
    end

    it "should calculate all weapon prices for Hunters" do
      @ip.price(:slot => 'Main Hand', :level => median_level, :class => 'Hunter').should eql(1.00)
      @ip.price(:slot => 'Ranged',    :level => median_level, :class => 'Hunter').should eql(4.00)
    end

    it "should calculate all weapon prices for Rogues" do
      @ip.price(:slot => 'One-Hand', :level => median_level, :class => 'Rogue').should eql(2.50)
      @ip.price(:slot => 'Thrown',   :level => median_level, :class => 'Rogue').should eql(1.00)
    end

    it "should calculate all weapon prices for Shaman" do
      @ip.price(:slot => 'Shield',    :level => median_level, :class => 'Shaman').should eql(1.50)
      @ip.price(:slot => 'One-Hand',  :level => median_level, :class => 'Shaman').should eql(2.50)
      @ip.price(:slot => 'Main Hand', :level => median_level, :class => 'Shaman').should eql(3.50)
    end

    it "should calculate all weapon prices for Warriors" do
      @ip.price(:slot => 'Shield',   :level => median_level, :class => 'Warrior').should eql(2.50)
      @ip.price(:slot => 'Off Hand', :level => median_level, :class => 'Warrior').should eql(2.50)
    end
  end

  context "trinket prices" do
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
  end

  context "special case items" do
    it "should calculate for Heroic Key to the Focusing Iris" do
      @ip.price(:name => 'Heroic Key to the Focusing Iris').should eql(0.00)
    end

    it "should calculate for Reply-Code Alpha" do
      @ip.price(:name => 'Reply-Code Alpha').should eql(0.00)
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
      @ip.price(:level => 80, :id => 52027).should eql(2.50)
    end

    it "should calculate for Conqueror's Mark of Sanctification (Heroic)" do
      @ip.price(:level => 80, :id => 52030).should eql(3.00)
    end
  end
end

describe ItemPrice, "weapon special cases" do
  before(:each) do
    @ip = ItemPrice.instance
  end

end
