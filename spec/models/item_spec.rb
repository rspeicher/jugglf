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
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @item = Item.make
  end
  
  it "should be valid" do
    @item.should be_valid
  end
  
  it "should have custom to_param" do
    @item.to_param.should eql("#{@item.id}-#{@item.name.parameterize}-#{@item.wow_id}")
  end
  
  it "should not include wow_id if it's nil" do
    @item.wow_id = nil
    @item.to_param.should eql("#{@item.id}-#{@item.name.parameterize}")
  end
  
  it "should return a Wowhead item link" do
    @item.wowhead_link.should match(/wowhead.com\/\?item=12345/)
  end
  
  it "should return a Wowhead icon link" do
    @item.wowhead_icon('medium').should eql("http://static.wowhead.com/images/icons/medium/inv_icon_01.jpg")
    @item.wowhead_icon(:large).should eql("http://static.wowhead.com/images/icons/large/inv_icon_01.jpg")
  end
  
  it "should return an empty string if the icon does not exist" do
    @item.icon = nil
    @item.wowhead_icon(:large).should eql('')
  end
  
  describe "uniqueness validation" do
    before(:each) do
      item = Item.make(:name => 'Warglaive of Azzinoth', :wow_id => 32837)
      item.should be_valid
    end

    it "should allow a duplicate name with a unique wow_id" do
      lambda { Item.make(:name => 'Warglaive of Azzinoth', :wow_id => 32838) }.should_not raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not allow a duplicate name with a duplicate wow_id" do
      lambda { Item.make(:name => 'Warglaive of Azzinoth', :wow_id => 32837) }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
  
  describe "#safely_rename" do
    before(:all) do
      Item.destroy_all
    end
    
    before(:each) do
      @wrong = Item.make(:name => 'Wrong')
      @right = Item.make(:name => 'Right')
    end
    
    it "should delete the old item" do
      Item.safely_rename(:from => @wrong, :to => @right.id)
      Item.find_by_name('Wrong').should be_nil
    end
  
    it "should update its loot children" do
      2.times { @wrong.loots.make }
      1.times { @right.loots.make }
      
      Item.safely_rename(:from => @wrong, :to => @right.id)
      
      @right.reload
      @right.loots.count.should eql(3)
      @right.loots_count.should eql(3)
    end
    
    it "should update its wishlist children" do
      1.times { @wrong.wishlists.make }
      2.times { @right.wishlists.make }
      
      Item.safely_rename(:from => @wrong, :to => @right.id)
      
      @right.reload
      @right.wishlists.count.should eql(3)
      @right.wishlists_count.should eql(3)
    end
    
    it "should update its loot table children" do
      @wrong.loot_tables.make
      
      Item.safely_rename(:from => @wrong, :to => @right.id)
      
      @right.reload
      @right.loot_tables.count.should eql(1)
    end
    
    it "should accept a string for each argument" do
      lambda { Item.safely_rename(:from => 'Wrong', :to => 'Right') }.should_not raise_error
    end
  end
end

describe Item, "#find_[or_create_]by_name_or_wow_id" do
  before(:each) do
    @item = Item.make(:name => 'Item', :wow_id => 12345)
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
  it "should return true if name is present but wow_id is not" do
    item = Item.make_unsaved(:wow_id => nil)
    item.name.present?.should be_true
    item.wow_id.present?.should be_false
    item.needs_lookup?.should be_true
  end
  
  it "should return true if wow_id is present but name is not" do
    item = Item.make_unsaved(:name => nil)
    item.name.present?.should be_false
    item.wow_id.present?.should be_true
    item.needs_lookup?.should be_true
  end
  
  it "should otherwise return false" do
    item = Item.make_unsaved(:with_real_stats)
    item.name.present?.should be_true
    item.wow_id.present?.should be_true
    item.needs_lookup?.should be_false
  end
end

describe Item, "automatic stat lookup" do
  before(:each) do
    Item.destroy_all
    @item = Item.make_unsaved(:wow_id => 40395)
    @item.stub!(:open).
      and_return(File.read(RAILS_ROOT + '/spec/fixtures/wowhead/item_40395.xml'))
  end
  
  it "should perform a lookup when name is nil" do
    @item.name = nil
    lambda { @item.save }.should change(@item, :name).to('Torch of Holy Fire')
  end
  
  it "should do nothing when name is not nil" do
    @item.name = "Item"
    lambda { @item.save }.should_not change(@item, :name)
  end
end

describe Item, "lookup from database" do
  before(:each) do
    @item = Item.make(:with_real_stats)
  end
  
  it "should perform lookup" do
    @item.should_not_receive(:stat_lookup)
    @item.lookup
  end
end
  
describe Item, "lookup from Internet" do
  # FIXME: We're kind of testing ItemLookup here, erroneously.
  # We should mock the return value from ItemLookup instead of letting it run.
  before(:each) do
    Item.destroy_all
    @item = Item.make(:name => 'Torch of Holy Fire', :wow_id => nil, :level => 0)
  end
  
  it "should fail silently if the item does not exist" do
    @item.name = 'This Item Does Not Exist'
    lambda { @item.lookup(true) }.should_not raise_error(Exception)
  end
  
  it "should perform lookup by name" do
    # Force a refresh
    @item.wow_id.should be_nil
    lambda { @item.lookup(true) }.should change(@item, :wow_id).to(40395)
  end
  
  it "should perform lookup by wow_id" do
    @item.name = nil
    @item.wow_id = 40395
    ItemLookup.should_receive(:search).with(40395, anything()).and_return(ItemLookup::Results.new)
    @item.lookup
  end
end
