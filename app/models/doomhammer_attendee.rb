class DoomhammerAttendee < ActiveRecord::Base
  set_table_name "eqdkp_raid_attendees"
  set_primary_key "attendee"
  
  def member_id
    # Get the DoomhammerMember record so that our renames still work
    dm = DoomhammerMember.find_by_member_name(self.member_name)
    
    if dm.nil?
      puts "Invalid attendee record: #{self.member_name}"
    else
      member = Member.find_by_name(dm.name)
    
      if member.nil?
        puts "Invalid member record: #{dm.name}"
      else
        return member.id
      end
    end
  end
  
  def attendance
    self.raid_attendance.to_f
  end
end
