require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "adjusted price" do
    assert_equal(0.50, items(:rot).adjusted_price)
  end
  
  # test "cannot access price directly" do
  #   i = items(:rot)
  #   assert_equal(false, i.respond_to?('price'))
  # end
  
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
      
      puts line unless items and items.length > 0
      
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
end
