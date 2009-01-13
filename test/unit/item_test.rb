require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "allows multiple items of the same name" do
    10.times do
      Item.create(:name => "Ubiquitous Item", :price => 3.14)
    end
    
    assert_equal(10, Item.all.count)
  end
end
