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
  
  alias_method :attendance, :attendees
  
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
      
      # Total possible attendance totals
      totals = {
        :thirty   => Raid.count_last_thirty_days * 1.00,
        :ninety   => Raid.count_last_ninety_days * 1.00,
        :lifetime => Raid.count * 1.00
      }
      
      # My attendance totals
      att = { :thirty => 0.00, :ninety => 0.00, :lifetime => 0.00 }
      self.attendance.each do |a|
        if totals[:thirty] > 0.00 and a.raid.is_in_last_thirty_days?
          att[:thirty] += a.attendance
        end
        
        if totals[:ninety] > 0.00 and a.raid.is_in_last_ninety_days?
          att[:ninety] += a.attendance
        end
        
        if totals[:lifetime] > 0.00
          att[:lifetime] += a.attendance
        end
      end
      
      self.attendance_30       = (att[:thirty]   / totals[:thirty])   if totals[:thirty]
      self.attendance_90       = (att[:ninety]   / totals[:ninety])   if totals[:ninety]
      self.attendance_lifetime = (att[:lifetime] / totals[:lifetime]) if totals[:lifetime]
      
      # Loot Factor
      lf = { :lf => 0.00, :sitlf => 0.00, :bislf => 0.00 }
      self.items.each do |i|
        if i.affects_loot_factor?
          if i.situational?
            lf[:sitlf] += i.price
          elsif i.best_in_slot?
            lf[:bislf] += i.price
          else
            lf[:lf] += i.price
          end
        end
      end
      
      unless self.attendance_30 == 0.0
        self.lf    = (lf[:lf]    / self.attendance_30)
        self.sitlf = (lf[:sitlf] / self.attendance_30)
        self.bislf = (lf[:bislf] / self.attendance_30)
      end
    end
end