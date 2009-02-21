require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include MembersHelper

describe MembersHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the MembersHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(MembersHelper)
  end
  
  describe "member_rank_with_formatting" do
    it "should return member.name if member.rank is nil" do
      m = mock_model(Member, :name => 'Name', :rank => nil)
      member_with_rank_formatting(m).should == m.name
    end
    
    it "should return a formatted name if member.rank is not nil" do
      m = mock_model(Member, :name => 'Name', 
        :rank => mock_model(MemberRank, :prefix => '<b>', :suffix => '</b>')
      )
      m.rank.should_receive(:format).and_return("#{m.rank.prefix}#{m.name}#{m.rank.suffix}")
      
      member_with_rank_formatting(m).should == "<b>Name</b>"
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
      m = mock_model(Member, :name => 'Name', :wow_class => 'WoWClass')
      link_to_member(m).should match(/class="WoWClass"/)
    end
    
    it "should ignore a nil value" do
      lambda { link_to_member(nil) }.should_not raise_error
    end
  end
  
  describe "member_raid_attendance" do
    it "should return zero for non-attended raid" do
      raid = mock_model(Raid, :members => [])
      
      member_raid_attendance(raid, mock_model(Member)).should match(/0%/)
    end
    
    it "should return member attendance for attended raid" do
      raid = mock_model(Raid, :members => [], :attendees => [])
      raid.members.should_receive(:include?).and_return(true)
      raid.attendees.should_receive(:find_by_member_id).and_return(
        mock_model(Member, :attendance => 0.50)
      )
      
      member_raid_attendance(raid, mock_model(Member)).should match(/50%/)
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
end