require 'test_helper'

class RaidTest < ActiveSupport::TestCase
  test "count last thirty days" do
    assert_equal(2, Raid.count_last_thirty_days)
  end
  
  test "count last ninety days" do
    assert_equal(3, Raid.count_last_ninety_days)
  end
end
