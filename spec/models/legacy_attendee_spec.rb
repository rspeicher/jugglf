# == Schema Information
# Schema version: 20090312150316
#
# Table name: mgdkp_raid_attendees
#
#  raid_id         :integer(3)      default(0), not null
#  member_name     :string(30)      default(""), not null
#  raid_attendance :float(3)        default(1.0), not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyAttendee do
  before(:each) do
    @member = Member.make
    @legacy = LegacyAttendee.create(:raid_attendance => 1.00, :member_name => @member.name)
  end
  
  it "should return a member id instead of member name" do
    @legacy.member_id.should == @member.id
  end
  
  it "should return nil if no member exists" do
    Member.destroy_all
    @legacy.member_id.should == nil
  end
  
  it "should return raid attendance" do
    @legacy.attendance.should == 1.00
  end
end
