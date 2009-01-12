# == Schema Information
# Schema version: 20090112080555
#
# Table name: members
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  active              :boolean(1)      default(TRUE)
#  first_raid          :date
#  last_raid           :date
#  raid_count          :integer(4)      default(0)
#  wow_class           :string(255)
#  lf                  :float           default(0.0)
#  sitlf               :float           default(0.0)
#  bislf               :float           default(0.0)
#  attendance_30       :float           default(0.0)
#  attendance_90       :float           default(0.0)
#  attendance_lifetime :float           default(0.0)
#  created_at          :datetime
#  updated_at          :datetime
#  uncached_updates    :integer(4)      default(0)
#

class Member < ActiveRecord::Base
  has_many :attendees
  has_many :items
  has_many :raids, :through => :attendees  
  
  before_save :update_cache
  after_update :increment_uncached_updates
  
  def should_recache?
    self.uncached_updates >= 2 or 12.hours.ago >= self.updated_at
  end
  
  private
    def increment_uncached_updates
      self.uncached_updates += 1 or 1
    end
    
    def update_cache
      return unless self.should_recache?
    end
end