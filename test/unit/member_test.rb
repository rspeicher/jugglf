require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test "should not recache based on updated_at" do
    m = members(:tsigo)
    
    assert_equal(false, m.should_recache?)
  end
  
  test "should recache based on updated_at" do
    m = members(:sebudai)
    
    assert_equal(true, m.should_recache?)
  end
  
  test "should recache based on uncached_updates" do
    m = members(:tsigo)
    m.uncached_updates = 2
    
    assert_equal(true, m.should_recache?)
  end
end
