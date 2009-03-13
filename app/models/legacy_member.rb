# == Schema Information
# Schema version: 20090312150316
#
# Table name: mgdkp_members
#
#  member_id         :integer(2)      not null, primary key
#  member_name       :string(30)      default(""), not null
#  member_earned     :float(11)       default(0.0), not null
#  member_spent      :float(11)       default(0.0), not null
#  member_adjustment :float(11)       default(0.0), not null
#  member_status     :boolean(1)      default(TRUE), not null
#  member_firstraid  :integer(4)      default(0), not null
#  member_lastraid   :integer(4)      default(0), not null
#  member_raidcount  :integer(4)      default(0), not null
#  member_level      :integer(1)      default(70), not null
#  member_race_id    :integer(2)      default(0), not null
#  member_class_id   :integer(2)      default(0), not null
#  member_rank_id    :integer(2)      default(0), not null
#  member_lf         :float(11)       default(0.0), not null
#  member_slf        :float(11)       default(0.0), not null
#  member_bis        :float(11)       default(0.0), not null
#  member_30         :float(3)        default(0.0), not null
#  member_90         :float(3)        default(0.0), not null
#  member_lt         :float(3)        default(0.0), not null
#

class LegacyMember < ActiveRecord::Base
  set_table_name "mgdkp_members"
  set_primary_key "member_id"
  
  def name
    self.member_name
  end
  
  def active
    self.member_status and self.member_rank_id != 5 and self.member_rank_id != 6
  end
  def active?
    self.active
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
  
  def rank_id
    self.member_rank_id
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
