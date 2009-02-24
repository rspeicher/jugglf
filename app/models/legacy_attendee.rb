# == Schema Information
# Schema version: 20090224005026
#
# Table name: mgdkp_raid_attendees
#
#  raid_id         :integer(3)      default(0), not null
#  member_name     :string(30)      default(""), not null
#  raid_attendance :float           default(1.0), not null
#

class LegacyAttendee < ActiveRecord::Base
  set_table_name "mgdkp_raid_attendees"
  set_primary_key "raid_member"
  
  def member_id
    Member.find_by_name(self.member_name).id
  end
  
  # def raid_id
  #   self.raid_id
  # end
  
  def attendance
    self.raid_attendance.to_f
  end
end
