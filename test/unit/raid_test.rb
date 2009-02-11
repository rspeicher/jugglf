require 'test_helper'

class RaidTest < ActiveSupport::TestCase
  fixtures :members
  
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
  
  test "should populate members from juggyattendance output" do
    Raid.delete_all
    
    output = File.read(File.expand_path(File.join(File.dirname(__FILE__), "raid_att_output.txt")))
    
    r = Raid.create(:date => Time.now, :note => "JuggyAttendance Output")
    assert_equal(0, r.members.count)
    
    r.attendance_output = output
    r.save
    
    assert_equal(32, r.members.count)
    
    m = r.members.find_by_name('Kapetal')
    assert_equal(0.83, m.attendance[0].attendance)
    
    tsigo = Member.find_by_name('Tsigo')
    assert_equal('Priest', tsigo.wow_class)
    assert_equal(1, tsigo.attendance.size)
    assert_equal(1.00, tsigo.attendance_30)
  end
  
  test "can prevent attendee cache update" do
    r = raids(:today)
    
    r.attendees << Attendee.create(:member_id => members(:tsigo).id, :attendance => 0.50)
    
    r.update_attendee_cache = false
    r.save!
    r.reload
    
    # Cache hasn't been updated yet, members' attendance should still be 100%
    assert_equal(1.00, Member.find_by_name('Tsigo').attendance_30)
    
    # Create a new object so the update_attendee_cache value doesn't linger around
    r1 = Raid.find(r.id)
    r1.save!
    
    assert_not_equal(1.00, Member.find_by_name('Tsigo').attendance_30)
  end
end
