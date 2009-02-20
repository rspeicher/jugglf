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
  end
  
  describe "link_to_member" do
    it "should return nil if member is nil" do
      link_to_member(nil).should == nil
    end
    
    it "should apply wow class as CSS class" do
      m = mock_model(Member, :name => 'Name', :wow_class => 'Druid')
      link_to_member(m).should match(/class="Druid"/)
    end
  end
  
  describe "member_raid_attendance" do
    it "should return zero for non-attended raid"
    it "should return member attendance for attended raid"
  end
  
  describe "member_attendance_colored" do
    it "should classify as negative for 0-34"
    it "should classify as neutral for 35-66"
    it "should classify as positive for 67-100"
    it "should otherwise classify as neutral"
  end
  
  describe "raid_attendance_colored" do
    it "should classify as positive for 100"
    it "should classify as neutral for 1-99"
    it "should classify as negative for 0"
  end
end