require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include MembersHelper

describe MembersHelper do
  
  describe "member_rank_with_formatting" do
    it "should return member.name if member.rank is nil" do
      m = Member.make
      member_with_rank_formatting(m).should == m.name
    end
    
    it "should return a formatted name if member.rank is not nil" do
      m = Member.make(:rank => MemberRank.make)
      member_with_rank_formatting(m).should == "<b>#{m.name}</b>"
    end
    
    it "should ignore a nil value" do
      lambda { member_with_rank_formatting(nil) }.should_not raise_error
    end
  end
  
  describe "link_to_member" do
    it "should return nil if member is nil" do
      link_to_member(nil).should == nil
    end
    
    it "should apply wow class as CSS class" do
      m = Member.make(:wow_class => 'Mage')
      link_to_member(m).should match(/class="Mage"/)
    end
  end
  
  describe "member_raid_attendance" do
    it "should return zero for non-attended raid" do
      raid = Raid.make
      member_raid_attendance(raid, mock_model(Member)).should match(/0%/)
    end
    
    it "should return member attendance for attended raid" do
      raid = Raid.make(:attendees => [Attendee.make(:attendance => 0.50)])
      member_raid_attendance(raid, raid.attendees[0].member).should match(/50%/)
    end
    
    it "should ignore nil values" do
      lambda { member_raid_attendance(nil, nil) }.should_not raise_error
    end
  end
  
  describe "member_attendance_colored" do
    it "should classify as negative for 0-34" do
      member_attendance_colored(18).should match(/negative/)
    end
    
    it "should classify as neutral for 35-66" do
      member_attendance_colored(48).should match(/neutral/)
    end
    
    it "should classify as positive for 67-100" do
      member_attendance_colored(88).should match(/positive/)
    end
    
    it "should otherwise classify as neutral" do
      member_attendance_colored(-1).should match(/neutral/)
    end
    
    it "should handle a float value" do
      member_attendance_colored(0.1234).should match(/12%/)
    end
    
    it "should ignore a nil value" do
      lambda { member_attendance_colored(nil) }.should_not raise_error
    end
  end
  
  describe "raid_attendance_colored" do
    it "should classify as positive for 100"do
      raid_attendance_colored(100).should match(/positive/)
    end
    
    it "should classify as neutral for 1-99" do
      raid_attendance_colored(50).should match(/neutral/)
    end
    
    it "should classify as negative for 0" do
      raid_attendance_colored(0).should match(/negative/)
    end
    
    it "should handle a float value" do
      raid_attendance_colored(0.1234).should match(/12%/)
    end
    
    it "should ignore a nil value" do
      lambda { raid_attendance_colored(nil) }.should_not raise_error
    end
  end
  
  describe "loot_factor" do
    it "should format a value" do
      loot_factor(1).should == '1.00'
    end
  end
end