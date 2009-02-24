# == Schema Information
# Schema version: 20090224005026
#
# Table name: attendees
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  raid_id    :integer(4)
#  attendance :float
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvisionUserConverge do
  before(:each) do
    @attendee = Attendee.make
  end
  
  it "should be valid" do
    @attendee.should be_valid
  end
end
