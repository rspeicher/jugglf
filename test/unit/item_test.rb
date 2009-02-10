require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  fixtures :item_stats, :members
    
  test "adjusted price" do
    assert_equal(0.50, items(:rot).adjusted_price)
  end
  
  test "allows multiple items of the same name" do
    Item.destroy_all
    
    10.times do
      Item.create(:name => "Ubiquitous Item", :price => 3.14)
    end
    
    assert_equal(10, Item.all.count)
  end
  
  test "populates single item from attendance output" do
    Item.destroy_all
    
    str = "Sebudai - [Arachnoid Gold Band]"
    items = Item.from_attendance_output(str)
    assert_equal(1, items.length)
  end
  
  test "populates multiple items from single attendance output line" do
    Item.destroy_all
    Member.destroy_all
    
    str = "Modrack (bis), Rosoo (bis) - [Crown of the Lost Vanquisher]"
    items = Item.from_attendance_output(str)
    assert_equal(2, items.length)
    assert_equal(true, items[0].best_in_slot?)
    
    # They shouldn't have actually been inserted yet
    assert_equal(0, Item.count)
    assert_equal(0, Member.count)
  end
  
  test "populates multiple items from multiple attendance output lines" do
    Item.destroy_all
    Member.destroy_all
    
    output = File.read(File.expand_path(File.join(File.dirname(__FILE__), "raid_loot_output.txt")))
    output.each do |line|
      items = Item.from_attendance_output(line)
      
      items.each do |item|
        item.save!
      end
    end
    
    assert_equal(64, Item.count)
    assert_equal(3, Member.find_by_name('Tsigo').items.size)
    assert_equal(1, Member.find_all_by_name('Tsigo').size)
  end
  
  test "populates and correctly identifies (bis rot)" do
    Item.destroy_all
    Member.destroy_all
    
    str = "Modrack (bis rot) - [Crown of the Lost Vanquisher]"
    items = Item.from_attendance_output(str)
    assert_equal(1, items.length)
    
    item = items[0]
    assert_equal(0.50, item.adjusted_price)
    assert_equal(true, item.best_in_slot?)
    assert_equal(false, item.situational?)
  end
  
  test "populates without false positive for tell types inside a name" do
    str = "Tsitgo (bis rot) - [Crown of the Lost Vanquisher]"
    item = Item.from_attendance_output(str)[0]
    
    assert_equal(true, item.rot?)
    assert_equal(true, item.best_in_slot?)
    assert_equal(false, item.situational?)
  end
  
  test "determines item price" do
    ip = ItemPrice.new
    
    # Trinket (Soul of the Dead) - 4.00 for everyone
    assert_equal(4.00, ip.price(item_stats(:trinket), false), "Trinket for everyone is 4.00")
    
    # Main Hand (Torch of Holy Fire) - 1.25 for Hunters, 4.00 for everyone else
    assert_equal(1.25, ip.price(item_stats(:mainhand), true), "Main Hand for Hunters is 1.25")
    assert_equal(4.00, ip.price(item_stats(:mainhand), false), "Main Hand for non-Hunters is 4.00")
    
    # Two-Hand (Betrayer of Humanity) - 2.50 for Hunters, 6.00 for everyone else
    assert_equal(2.50, ip.price(item_stats(:twohand), true), "Two-Hand for Hunters is 2.50")
    assert_equal(6.00, ip.price(item_stats(:twohand), false), "Two-Hand for non-Hunters is 6.00")
    
    # One-Hand (Sinister Revenge) - 1.25 for Hunters (MH/OH), 4.00 for everyone else (MH), 2.00 for everyone else (OH)
    assert_equal(1.25, ip.price(item_stats(:onehand), true), "One-Hand for Hunters is 1.25")
    assert_equal([4.00, 2.00], ip.price(item_stats(:onehand), false), "One-Hand for non-Hunters is 4.00 or 2.00")
    
    # Neck (Heroic Key to the Focusing Iris), special turn-in item condition - 2.50 for everyone
    assert_equal(2.50, ip.price(item_stats(:quest_item), false), "Heroic Key to the Focusing Iris is 2.50 for everyone")
    
    # Chest Token (Breastplate of the Lost Conqueror), special turn-in item condition - 2.50 for everyone
    assert_equal(2.50, ip.price(item_stats(:chest_token), true), "Breastplate of the Lost Conqueror is 2.50 for everyone")
    
    # Now test via an Item instance rather than ItemPrice
    i = Item.create(:name => 'Torch of Holy Fire', :member => members(:tsigo))
    assert_equal(4.00, i.determine_item_price())
    
    i = Item.create(:name => 'Torch of Holy Fire', :member => members(:sebudai))
    assert_equal(1.25, i.determine_item_price())
  end
end
