require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemStat do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    ItemStat.create!(@valid_attributes)
  end
  
  it "should return a Wowhead item link" do
    stat = ItemStat.lookup_by_name('Torch of Holy Fire')
    
    stat.wowhead_link.should == "http://www.wowhead.com/?item=40395"
  end
  
  it "should return a Wowhead icon link" do
    stat = ItemStat.lookup_by_name('Torch of Holy Fire')
    
    stat.wowhead_icon('medium').should == "http://static.wowhead.com/images/icons/medium/inv_mace_82.jpg"
  end
  
  # ---------------------------------------------------------------------------
  
  describe "lookup from database" do
    it "should perform lookup by item id" do
      validate_database_lookup(ItemStat.lookup_by_id(40395))
    end
    
    it "should perform lookup by item name" do
      validate_database_lookup(ItemStat.lookup_by_name('TORCH OF HOLY FIRE'))
    end
    
    def validate_database_lookup(stat)
      stat.item_id.should == 40395
      stat.item.should    == 'Torch of Holy Fire'
      stat.color.should   == 'q4'
      stat.icon.should    == 'INV_Mace_82'
      stat.level.should   == 226
      stat.slot.should    == 'Main Hand'
    end
  end
  
  # ---------------------------------------------------------------------------
  
  describe "lookup from Wowhead" do
    before(:each) do
      # ItemStat.destoy_all # FIXME: Why doesn't this work?
    end
    
    it "should perform lookup by item id" do
      validate_wowhead_lookup(ItemStat.lookup_by_id(32837))
    end
    
    it "should perform lookup by item name" do
      validate_wowhead_lookup(ItemStat.lookup_by_name('warglaive of azzinoth'))
    end
    
    def validate_wowhead_lookup(stat)
      stat.item_id.should == 32837
      stat.item.should    == 'Warglaive of Azzinoth'
      stat.level.should   == 156
      stat.color.should   == 'q5'
      stat.slot.should    == 'Main Hand'
      stat.icon.should    == 'INV_Weapon_Glave_01'
    end
  end
end
