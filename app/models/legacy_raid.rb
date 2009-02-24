# == Schema Information
# Schema version: 20090224005026
#
# Table name: mgdkp_raids
#
#  raid_id         :integer(4)      not null, primary key
#  raid_name       :string(255)
#  raid_date       :integer(4)      default(0), not null
#  raid_note       :string(255)
#  raid_value      :float           default(0.0), not null
#  raid_added_by   :string(30)      default(""), not null
#  raid_updated_by :string(30)
#  raid_thread     :integer(4)      default(0), not null
#

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
