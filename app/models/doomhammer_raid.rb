class DoomhammerRaid < ActiveRecord::Base
  set_table_name "eqdkp_raids"
  set_primary_key "raid_id"
  
  def date
    Time.at(self.raid_date).to_date
  end
end
