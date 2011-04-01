require 'spec_helper'

describe LiveLoot do
  subject { Factory(:live_loot) }

  it { should be_valid }

  context "mass assignment" do
    it { should allow_mass_assignment_of(:wow_id) }
    it { should allow_mass_assignment_of(:item_id) }
    it { should allow_mass_assignment_of(:member_id) }
    it { should allow_mass_assignment_of(:member_name) }
    it { should allow_mass_assignment_of(:loot_type) }
    it { should_not allow_mass_assignment_of(:live_raid) }
    it { should_not allow_mass_assignment_of(:live_raid_id) }
  end

  context "associations" do
    it { should belong_to(:item) }
    it { should belong_to(:member) }
    it { should belong_to(:live_raid) }
  end

  context "validations" do
    it { should allow_value(nil).for(:loot_type) }
    it { should allow_value('bis').for(:loot_type) }
    it { should allow_value('rot').for(:loot_type) }
    it { should allow_value('sit').for(:loot_type) }
    it { should allow_value('bisrot').for(:loot_type) }
    it { should_not allow_value('invalid').for(:loot_type) }
    it { should_not allow_value('BiS').for(:loot_type) }
  end
end

describe LiveLoot, "item assocation" do
  describe "with an existing item" do
    before do
      @item      = Factory(:item)
      @live_loot = Factory.build(:live_loot)
    end

    it "should set the value of item_id based on wow_id, if given" do
      lambda { @live_loot.wow_id = @item.id }.should change(@live_loot, :item_id).to(@item.id)
    end
  end

  describe "with a new item" do
    # TODO: Should we just let it make the item?
  end
end

describe LiveLoot, "member association" do
  describe "with an existing member" do
    before do
      @member    = Factory(:member)
      @live_loot = Factory.build(:live_loot)
    end

    it "should set the value of member_id based on member_name" do
      lambda { @live_loot.member_name = @member.name }.should change(@live_loot, :member_id).to(@member.id)
    end
  end

  context "with a new member" do
    before do
      @live_loot = Factory.build(:live_loot)
    end

    it "should invalidate" do
      @live_loot.member_name = 'InvalidMember'
      @live_loot.should have(1).errors_on(:member)
    end
  end
end

describe LiveLoot, ".from_text" do
  before(:all) do
    @text = "DE, Tsigo - [Torch of Holy Fire]|40395\n" +
            "Tsigo - [Torch of Holy Fire]|40395\n" +
            "Tsigo (sit) - [Torch of Holy Fire]|40395\n" +
            "Tsigo BIS - [Torch of Holy Fire]|40395\n"
  end

  it "should return an empty array if no text is given" do
    LiveLoot.from_text(nil).should eql([])
  end

  describe "parsing invalid text" do
    it "should not parse an empty buyer string" do
      lambda { LiveLoot.from_text(" - [Torch of Holy Fire]|40395") }.should raise_error(RuntimeError)
    end
  end

  describe "parsing valid text" do
    before do
      @member = Factory(:member, :name => 'Tsigo')
      @item   = Factory(:item_with_real_stats)

      @expected = [
        { :wow_id => 40395, :item => @item, :member => nil,     :loot_type => nil },
        { :wow_id => 40395, :item => @item, :member => @member, :loot_type => nil },
        { :wow_id => 40395, :item => @item, :member => @member, :loot_type => nil },
        { :wow_id => 40395, :item => @item, :member => @member, :loot_type => 'sit' },
        { :wow_id => 40395, :item => @item, :member => @member, :loot_type => 'bis' },
      ]

      @loots = LiveLoot.from_text(@text)
    end

    it "should return an array of LiveLoot objects" do
      @loots.length.should eql(5)
      @loots[0].should be_a(LiveLoot)
    end

    it "should not save the LiveLoot records" do
      @loots[0].new_record?.should be_true
    end

    0.upto(4) do |i|
      describe "Loot #{i}" do
        %w(wow_id item member loot_type).each do |param|
          it "should correctly set the #{param} attribute" do
            @loots[i].send(param).should eql(@expected[i][param.intern])
          end
        end
      end
    end
  end
end
