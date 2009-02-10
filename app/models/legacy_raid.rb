class LegacyRaid < ActiveRecord::Base
  set_table_name "mgdkp_raids"
  set_primary_key "raid_id"
  
  def date
    self.raid_name
  end
  
  def note
    self.raid_note
  end
  
  def thread
    self.raid_thread
  end
  
  def attendees_count
    # TODO?
  end
  
  def attendees
    retval = []
    
    LegacyAttendee.find_all_by_raid_id(self.raid_id).each do |la|
      retval << Attendee.create(:member_id => la.member_id, :raid_id => la.raid_id, :attendance => la.attendance)
    end
    
    retval
  end
end
