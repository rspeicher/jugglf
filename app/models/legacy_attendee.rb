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
