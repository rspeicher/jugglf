require 'test_helper'

class ItemStatTest < ActiveSupport::TestCase
  test "performs lookup by name" do
    stat = ItemStat.lookup_by_name('warglaive of azzinoth')
    
    assert_equal(32837, stat.item_id)
    assert_equal('Warglaive of Azzinoth', stat.item)
    assert_equal(156, stat.level)
    assert_equal('q5', stat.color)
    assert_equal('Main Hand', stat.slot)
    assert_equal('INV_Weapon_Glave_01', stat.icon)
  end
  
  test "performs lookup by id" do
    stat = ItemStat.lookup_by_item_id(40395)
    
    assert_equal(40395, stat.item_id)
    assert_equal('Torch of Holy Fire', stat.item)
    assert_equal(226, stat.level)
    assert_equal('q4', stat.color)
    assert_equal('Main Hand', stat.slot)
    assert_equal('INV_Mace_82', stat.icon)
  end
  
  test "wowhead icon" do
    
    stat = ItemStat.lookup_by_name('Torch of Holy Fire')
    
    assert_equal("http://static.wowhead.com/images/icons/medium/inv_mace_82.jpg", stat.wowhead_icon('medium'))
  end
end
