# == Schema Information
# Schema version: 20090112080555
#
# Table name: raids
#
#  id         :integer(4)      not null, primary key
#  date       :date
#  note       :string(255)
#  thread     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Raid < ActiveRecord::Base
  has_many :attendees
  has_many :items
  has_many :members, :through => :attendees
  
  def is_in_last_thirty_days?
    self.date >= 30.days.ago.to_datetime
  end
  def is_in_last_ninety_days?
    self.date >= 90.days.ago.to_datetime
  end
  
  def self.count_last_thirty_days
    Raid.count(:conditions => [ "date >= ?", 30.days.ago ])
  end
  def self.count_last_ninety_days
    Raid.count(:conditions => [ "date >= ?", 90.days.ago ])
  end
end
