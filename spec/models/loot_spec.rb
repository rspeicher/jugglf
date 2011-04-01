require 'spec_helper'

describe Loot do
  subject { Factory(:loot) }

  it { should be_valid }

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should allow_mass_assignment_of(:item) }
    it { should allow_mass_assignment_of(:item_id) }
    it { should allow_mass_assignment_of(:item_name) }
    it { should allow_mass_assignment_of(:price) }
    it { should allow_mass_assignment_of(:purchased_on) }
    it { should allow_mass_assignment_of(:best_in_slot) }
    it { should allow_mass_assignment_of(:situational) }
    it { should allow_mass_assignment_of(:rot) }
    it { should allow_mass_assignment_of(:member) }
    it { should allow_mass_assignment_of(:member_id) }
    it { should allow_mass_assignment_of(:member_name) }
    it { should allow_mass_assignment_of(:raid) }
    it { should allow_mass_assignment_of(:raid_id) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
    it { should allow_mass_assignment_of(:update_cache) }
  end

  context "associations" do
    it { should belong_to(:item) }
    it { should belong_to(:member) }
    it { should belong_to(:raid) }
  end

  context "validations" do
    it { should validate_numericality_of(:price) }
  end
end

describe Loot, "adjusted_price" do
  before do
    @loot = Factory(:loot, :price => 1.00)
  end

  it "should return the correct adjusted price for rot loots" do
    @loot.adjusted_price.should eql(1.00)

    @loot.rot = true
    @loot.adjusted_price.should eql(0.50)
  end
end

describe Loot, "affects_loot_factor?" do
  before do
    @loot = Factory(:loot, :purchased_on => Date.today)
  end

  it "should return false if purchased_on is blank" do
    @loot.purchased_on = nil
    @loot.affects_loot_factor?.should be_false
  end

  it "should know whether or not it affects loot factor" do
    @loot.affects_loot_factor?.should be_true

    @loot.purchased_on = 1.year.ago
    @loot.affects_loot_factor?.should be_false
  end
end

describe Loot, "#has_purchase_type?" do
  before do
    @loot = Factory.build(:loot)
  end

  it "should return nil for bogus types" do
    @loot.has_purchase_type?('bogus').should be_nil
  end

  it "should know :best_in_slot?" do
    @loot.best_in_slot = true
    @loot.has_purchase_type?(:best_in_slot).should be_true
  end

  it "should know :situational?" do
    @loot.situational = true
    @loot.has_purchase_type?(:situational).should be_true
  end

  it "should know :rot?" do
    @loot.has_purchase_type?(:rot).should be_false
  end

  it "should know :normal?" do
    @loot.has_purchase_type?('NORMAL?').should be_true
  end
end

describe Loot, "#update_cache" do
  before do
    @loot = Factory.build(:loot_with_buyer, :price => 15.00)

    @member = @loot.buyer
    @member.update_attribute(:lf, 1.00)
  end

  it "should update buyer cache unless disabled" do
    lambda {
      @loot.update_cache = true
      @loot.save
      @member.reload
    }.should change(@member, :lf).to(1500.00)
  end

  it "should allow disabling of buyer cache updates" do
    lambda {
      @loot.update_cache = false
      @loot.save
      @member.reload
    }.should_not change(@member, :lf)
  end
end

describe Loot, "#set_purchased_on" do
  before do
    @loot = Factory.build(:loot, :raid => Factory(:raid))
  end

  it "should set purchased_on" do
    @loot.purchased_on = nil

    lambda { @loot.save }.should change(@loot, :purchased_on).from(nil).to(Date.today)
  end
end

describe Loot, "#item_name" do
  before do
    @loot = Factory(:loot)
  end

  it "should return item id if present" do
    @loot.item_name.should eql(@loot.item.id)
  end

  it "should otherwise return nil" do
    @loot.item_id = nil
    @loot.item_name.should be_nil
  end

  it "should assign item from string" do
    item = Factory(:item)
    @loot.item_name = item.name
    @loot.item.should eql(item)
  end
end

describe Loot, "#member_name" do
  before do
    @loot = Factory(:loot_with_buyer)
  end

  it "should return member's name if not nil" do
    @loot.member_name.should eql(@loot.member.name)
  end

  it "should return nil if member_id is nil" do
    @loot.member_id = nil
    @loot.member_name.should be_nil
  end

  it "should assign member from string" do
    member = Factory(:member)
    @loot.member_name = member.name
    @loot.member.should eql(member)
  end
end
