# == Schema Information
# Schema version: 20090112080555
#
# Table name: attendees
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  raid_id    :integer(4)
#  attendance :float
#

class Attendee < ActiveRecord::Base
  belongs_to :member
  belongs_to :raid
  
  def to_s
    attendance.to_s
  end
end
