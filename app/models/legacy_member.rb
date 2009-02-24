class LegacyMember < ActiveRecord::Base
  set_table_name "mgdkp_members"
  set_primary_key "member_id"
  
  def name
    self.member_name
  end
  
  def active
    self.member_status and self.member_rank_id != 5 and self.member_rank_id != 6
  end
  
  def first_raid
    Time.at(self.member_firstraid).to_s :db
  end
  
  def last_raid
    Time.at(self.member_lastraid).to_s :db
  end
  
  def raids_count
    #self.member_raidcount # Might just want to recalculate this manually
    0
  end
  
  def wow_class
    case self.member_class_id
    when 1
      'Druid'
    when 2
      'Hunter'
    when 3
      'Mage'
    when 4
      'Paladin'
    when 5
      'Priest'
    when 6
      'Rogue'
    when 7
      'Shaman'
    when 8
      'Warlock'
    when 9
      'Warrior'
    when 10
      'Death Knight'
    end
  end
  
  def lf
    self.member_lf
  end
  
  def sitlf
    self.member_slf
  end
  
  def bislf
    self.member_bis
  end
  
  def attendance_30
    self.member_30
  end
  
  def attendance_90
    self.member_90
  end
  
  def attendance_lifetime
    self.member_lt
  end
end
