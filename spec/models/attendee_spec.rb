# == Schema Information
#
# Table name: attendees
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  raid_id    :integer(4)
#  attendance :float
#

require 'spec_helper'

describe Attendee do
  before(:each) do
    @attendee = Attendee.make
  end
  
  it "should be valid" do
    @attendee.should be_valid
  end
  
  it { should belong_to(:member) }
  it { should belong_to(:raid) }
  
  it { should validate_presence_of(:member) }
  it { should validate_presence_of(:raid) }
  
  it "should have a custom to_s" do
    @attendee.to_s.should eql("#{@attendee.member.name} on #{@attendee.raid.date}")
  end
end
