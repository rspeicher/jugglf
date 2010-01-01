# == Schema Information
#
# Table name: live_attendees
#
#  id               :integer(4)      not null, primary key
#  member_name      :string(255)     not null
#  live_raid_id     :integer(4)
#  started_at       :datetime
#  stopped_at       :datetime
#  active           :boolean(1)      default(TRUE)
#  minutes_attended :integer(4)      default(0)
#

require 'spec_helper'

describe LiveAttendee do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    LiveAttendee.create!(@valid_attributes)
  end
end
