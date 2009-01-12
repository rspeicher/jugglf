require 'test_helper'

class RaidTest < ActiveSupport::TestCase
  test "raid is in last <x> days methods" do
    r = raids(:yesterday)
    assert_equal(true, r.is_in_last_thirty_days?)
    assert_equal(true, r.is_in_last_ninety_days?)
    
    r = raids(:two_months_ago)
    assert_equal(false, r.is_in_last_thirty_days?)
    assert_equal(true, r.is_in_last_ninety_days?)
  end
  
  test "day counts return zero with no records" do
    Raid.destroy_all
    
    assert_equal(0, Raid.count_last_ninety_days)
  end
  
  test "count last thirty days" do
    assert_equal(2, Raid.count_last_thirty_days)
  end
  
  test "count last ninety days" do
    assert_equal(3, Raid.count_last_ninety_days)
  end
end
