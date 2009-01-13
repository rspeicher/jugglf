# == Schema Information
# Schema version: 20090113041939
#
# Table name: raids
#
#  id              :integer(4)      not null, primary key
#  date            :date
#  note            :string(255)
#  thread          :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  items_count     :integer(4)      default(0)
#  attendees_count :integer(4)      default(0)
#

class Raid < ActiveRecord::Base
  has_many :attendees
  has_many :items, :order => "items.name ASC"
  has_many :members, :through => :attendees, :order => "name ASC"
  
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
  
  def attendance_output
    require 'csv'
    out = ""
    
    CSV::Writer.generate(out) do |csv|
      self.attendees.each do |a|
        csv << [ a.member.name, a.attendance ]
      end
    end
    
    out
  end
  def attendance_output=(value)
    require 'csv'
    lines = CSV.parse(value) do |line|
      m = Member.find_or_create_by_name(line[0])
      
      self.attendees << Attendee.create(:member => m, :attendance => line[1])
    end
  end
end
