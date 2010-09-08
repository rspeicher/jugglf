require 'spec_helper'

describe Item do
  include ItemLookupHelpers

  before(:each) do
    @item = Factory(:item_with_real_stats)
    ItemLookup.stubs(:search).returns(valid_lookup_results)
  end

  it "should be valid" do
    @item.should be_valid
  end

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should allow_mass_assignment_of(:name) }
    it { should_not allow_mass_assignment_of(:wishlists_count) }
    it { should_not allow_mass_assignment_of(:loots_count) }
    # it { should allow_mass_assignment_of(:wow_id) }
    it { should allow_mass_assignment_of(:color) }
    it { should allow_mass_assignment_of(:icon) }
    it { should allow_mass_assignment_of(:level) }
    it { should allow_mass_assignment_of(:slot) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
    it { should allow_mass_assignment_of(:heroic) }
    it { should_not allow_mass_assignment_of(:authentic) }
  end

  context "associations" do
    it { should have_many(:loots).dependent(:destroy) }
    it { should have_many(:wishlists).dependent(:destroy) }
    it { should have_many(:loot_tables).dependent(:destroy) }
  end

  context "validations" do
    it { should_not allow_value(nil).for(:id) }
    it { should_not allow_value(0).for(:id) }
    it { should allow_value('1').for(:id) }
    it { should allow_value(12345).for(:id) }

    it { should validate_uniqueness_of(:id) }
    it { should validate_uniqueness_of(:name).scoped_to(:id) }
  end

  it "should have a custom to_s" do
    @item.to_s.should eql("#{@item.id}-#{@item.name}")
  end

  describe "to_param" do
    it "should use name and id if available" do
      @item.to_param.should eql("#{@item.id}-#{@item.name.parameterize}")
    end

    it "should return just the ID if name is not available" do
      @item.name = nil
      @item.to_param.should eql(@item.id.to_s)
    end
  end
end

describe Item, "#find_[or_create_]by_name_or_id" do
  before(:each) do
    @item = Factory(:item_with_real_stats)
  end

  it "should find by id when given a numeric string" do
    Item.find_or_create_by_name_or_id(@item.id.to_s).should eql(@item)
    Item.find_by_name_or_id(@item.id.to_s).should eql(@item)
  end

  it "should find by id when given an integer" do
    Item.find_or_create_by_name_or_id(@item.id).should eql(@item)
    Item.find_by_name_or_id(@item.id).should eql(@item)
  end

  it "should find by name when given a non-numeric string" do
    Item.find_or_create_by_name_or_id(@item.name).should eql(@item)
    Item.find_by_name_or_id(@item.name).should eql(@item)
  end
end

describe Item, "#needs_lookup?" do
  it "should be based on authentic" do
    real = Factory.build(:item_with_real_stats)
    real.needs_lookup?.should be_false

    fake = Factory.build(:item, :authentic => false)
    fake.needs_lookup?.should be_true
  end
end

describe Item, "automatic stat lookup before save" do
  include ItemLookupHelpers

  describe "with a valid item" do
    it "should perform a lookup when name is nil" do
      item = Factory(:item_needing_lookup_via_id)
      lambda {
        ItemLookup.expects(:search).with(item.id, anything()).returns(valid_lookup_results)
        item.save
      }.should change(item, :name).from(nil).to('Torch of Holy Fire')
    end

    it "should do nothing when name is not nil" do
      item = Factory.build(:item_with_real_stats)
      ItemLookup.expects(:search).never
      lambda { item.save }.should_not change(item, :name)
    end
  end

  describe "with an invalid item" do
    before(:each) do
      @item = Factory(:item_needing_lookup_via_id)
      ItemLookup.expects(:search).with(1, anything()).at_least_once.returns(invalid_lookup_results)
    end

    it "should invalidate record when name is nil after lookup" do
      @item.should_not be_valid
      @item.should have(1).errors_on(:base)
    end
  end
end

describe Item, "#lookup!" do
  before(:each) do
    @item = Factory(:item)
  end

  it "should call lookup" do
    @item.expects(:lookup).with(true)
    @item.stubs(:save).returns(true)
    @item.lookup!(true)
  end

  it "should call save" do
    @item.stubs(:lookup).returns(true)
    @item.expects(:save).returns(true)
    @item.lookup!(true)
  end
end

describe Item, "#lookup" do
  include ItemLookupHelpers

  it "should not perform a lookup unless it's necessary" do
    item = Factory(:item_with_real_stats)
    ItemLookup.expects(:search).never
    item.lookup
  end

  context "when a lookup is needed" do
    context "with invalid item" do
      it "should fail silently" do
        item = Factory(:item_needing_lookup, :name => 'Invalid Item')
        lambda {
          ItemLookup.expects(:search).with(item.name, anything()).returns(invalid_lookup_results)
          item.lookup(true)
        }.should_not raise_error(Exception)
      end
    end

    context "with valid item" do
      before(:each) do
        @item = Factory.build(:item_with_real_stats)
      end

      it "should perform lookup by name" do
        @item.id = nil
        ItemLookup.expects(:search).with('Torch of Holy Fire', anything()).returns(valid_lookup_results)
        lambda { @item.lookup(true) }.should change(@item, :id).from(nil).to(40395)
      end

      it "should perform lookup by id" do
        @item.name = nil
        ItemLookup.expects(:search).with(40395, anything()).returns(valid_lookup_results)
        lambda { @item.lookup(true) }.should change(@item, :name).from(nil).to('Torch of Holy Fire')
      end
    end
  end
end
