# == Schema Information
# Schema version: 20090312150316
#
# Table name: mgdkp_raids
#
#  raid_id         :integer(3)      not null, primary key
#  raid_name       :string(255)
#  raid_date       :integer(4)      default(0), not null
#  raid_note       :string(255)
#  raid_value      :float(11)       default(0.0), not null
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
end
