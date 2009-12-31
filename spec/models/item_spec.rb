# == Schema Information
#
# Table name: items
#
#  id              :integer(4)      not null, primary key
#  name            :string(100)
#  wishlists_count :integer(4)      default(0)
#  loots_count     :integer(4)      default(0)
#  wow_id          :integer(4)
#  color           :string(15)
#  icon            :string(255)
#  level           :integer(4)      default(0)
#  slot            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  heroic          :boolean(1)
#  authentic       :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @item = Item.make(:with_real_stats)
  end
  
  it "should be valid" do
    @item.should be_valid
  end
  
  it { should have_many(:loots) }
  it { should have_many(:wishlists) }
  it { should have_many(:loot_tables) }
  
  it { should_not allow_mass_assignment_of(:id) }
  it { should allow_mass_assignment_of(:name) }
  it { should_not allow_mass_assignment_of(:wishlists_count) }
  it { should_not allow_mass_assignment_of(:loots_count) }
  it { should allow_mass_assignment_of(:wow_id) }
  it { should allow_mass_assignment_of(:color) }
  it { should allow_mass_assignment_of(:icon) }
  it { should allow_mass_assignment_of(:level) }
  it { should allow_mass_assignment_of(:slot) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }
  it { should allow_mass_assignment_of(:heroic) }
  it { should_not allow_mass_assignment_of(:authentic) }
  
  it { should validate_uniqueness_of(:name).scoped_to(:wow_id) }
  # it { should validate_uniqueness_of(:wow_id) } # FIXME: Performs a lookup
  
  describe "to_param" do
    it "should use name and wow_id if available" do
      @item.to_param.should eql("#{@item.id}-#{@item.name.parameterize}-#{@item.wow_id}")
    end
    
    it "should not include wow_id if it's nil" do
      @item.wow_id = nil
      @item.to_param.should eql("#{@item.id}-#{@item.name.parameterize}")
    end
    
    it "should return just the ID if name or wow_id are not available" do
      @item.name = nil
      @item.to_param.should eql(@item.id.to_s)
    end
  end
end

describe Item, "#find_[or_create_]by_name_or_wow_id" do
  before(:each) do
    @item = Item.make(:name => 'Item', :wow_id => 12345, :authentic => true)
  end

  it "should find by wow_id when given a numeric string" do
    Item.find_or_create_by_name_or_wow_id('12345').should eql(@item)
    Item.find_by_name_or_wow_id('12345').should eql(@item)
  end

  it "should find by wow_id when given an integer" do
    Item.find_or_create_by_name_or_wow_id(12345).should eql(@item)
    Item.find_by_name_or_wow_id(12345).should eql(@item)
  end

  it "should find by name when given a non-numeric string" do
    Item.find_or_create_by_name_or_wow_id('Item').should eql(@item)
    Item.find_by_name_or_wow_id('Item').should eql(@item)
  end
end

describe Item, "#needs_lookup?" do
  it "should be based on authentic" do
    real = Item.make_unsaved(:with_real_stats)
    real.needs_lookup?.should be_false
    
    fake = Item.make_unsaved(:authentic => false)
    fake.needs_lookup?.should be_true
  end
end


# Stub out the return value of ItemLookup.search, so we're testing its usage
# and not its implementation
def valid_results
  results = ItemLookup::Results.new
  result = ItemLookup::Result.new({
    :id      => 40395,
    :name    => 'Torch of Holy Fire',
    :quality => 4,
    :icon    => 'INV_Mace_82',
    :level   => 226,
    :heroic  => false
  })
  results << result
end
def invalid_results
  results = ItemLookup::Results.new
  result = ItemLookup::Result.new
  results << result
end

describe Item, "automatic stat lookup before save" do
  describe "with a valid item" do
    before(:each) do
      Item.destroy_all
      @item = Item.make_unsaved(:wow_id => 40395, :name => nil)
    end
  
    it "should perform a lookup when name is nil" do
      lambda {
        ItemLookup.should_receive(:search).with(40395, anything()).and_return(valid_results)
        @item.save
      }.should change(@item, :name).from(nil).to('Torch of Holy Fire')
    end
  
    it "should do nothing when name is not nil" do
      ItemLookup.should_not_receive(:search)
      @item.name = "Item"
      lambda { @item.save }.should_not change(@item, :name)
    end
  end
  
  describe "with an invalid item" do
    before(:each) do
      Item.destroy_all
      @item = Item.make_unsaved(:wow_id => 654321, :name => nil, :authentic => false)
      ItemLookup.should_receive(:search).with(654321, anything()).and_return(invalid_results)
    end
    
    it "should invalidate record when name is nil after lookup" do
      @item.should have(1).errors_on(:base)
    end
  end
end

describe Item, "#lookup" do
  it "should not perform a lookup unless it's necessary" do
    item = Item.make(:with_real_stats)
    ItemLookup.should_not_receive(:search)
    item.lookup
  end
  
  describe "when a lookup is needed" do
    before(:each) do
      Item.destroy_all
    end
  
    describe "with invalid item" do
      it "should fail silently" do
        item = Item.make_unsaved(:wow_id => nil, :name => 'This Item Does Not Exist')
        lambda {
          ItemLookup.should_receive(:search).with(item.name, anything()).and_return(invalid_results)
          item.lookup(true)
        }.should_not raise_error(Exception)
      end
    end
  
    describe "with valid item" do
      it "should perform lookup by name" do
        item = Item.make_unsaved(:wow_id => nil, :name => 'Torch of Holy Fire')
        ItemLookup.should_receive(:search).with('Torch of Holy Fire', anything()).and_return(valid_results)
        lambda { item.lookup(true) }.should change(item, :wow_id).from(nil).to(40395)
      end

      it "should perform lookup by wow_id" do
        item = Item.make_unsaved(:wow_id => 40395, :name => nil)
        ItemLookup.should_receive(:search).with(40395, anything()).and_return(valid_results)
        lambda { item.lookup(true) }.should change(item, :name).from(nil).to('Torch of Holy Fire')
      end
    end
  end
end
