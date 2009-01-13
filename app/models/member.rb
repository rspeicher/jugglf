# == Schema Information
# Schema version: 20090113041939
#
# Table name: members
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  active              :boolean(1)      default(TRUE)
#  first_raid          :date
#  last_raid           :date
#  raids_count         :integer(4)      default(0)
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
#  items_count         :integer(4)      default(0)
#

class Member < ActiveRecord::Base
  CACHE_FLUSH = 1
  WOW_CLASSES = ['Death Knight'] + (%w(Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior))
  
  # Relationships -------------------------------------------------------------
  has_many :attendees
  has_many :items, :order => "id DESC" # FIXME: This should really be 'date DESC' but the date comes from the raid
  has_many :raids, :through => :attendees, :order => "date DESC"
  alias_method :attendance, :attendees
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :name
  validates_uniqueness_of :name, :message => "%s has already been taken"
  # validates_inclusion_of :wow_class, :in => WOW_CLASSES, :message => "is not a valid WoW class"
  
  # Callbacks -----------------------------------------------------------------
  # after_save :update_cache # update_cache is called by raid's after_save now
  
  # Methods -------------------------------------------------------------------
  def should_recache?
    # num. uncached updates>=threshold  | can't use new record | more than 12 hours old
    self.uncached_updates >= CACHE_FLUSH or (self.updated_at and 12.hours.ago >= self.updated_at)
  end
  
  def force_recache!
    update_cache(true)
  end
  
  def self.update_all_cache
    Member.find_all_by_active(true).each { |m| m.force_recache! }
  end
  
  private
    def update_cache(force = false)
      return unless force or self.should_recache?
      
      logger.info "update_cache running on #{self.name} -----------------------"
      
      # Total possible attendance totals
      totals = {
        :thirty   => Raid.count_last_thirty_days * 1.00,
        :ninety   => Raid.count_last_ninety_days * 1.00,
        :lifetime => Raid.count * 1.00
      }
      
      # My attendance totals
      att = { :thirty => 0.00, :ninety => 0.00, :lifetime => 0.00 }
      Attendee.find(:all, :include => :raid, :conditions => ["member_id = ? AND attendance > 0", self.id]).each do |a|
      # self.attendance.each do |a|
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
      
      self.attendance_30       = (att[:thirty]   / totals[:thirty])   unless totals[:thirty]   == 0.00
      self.attendance_90       = (att[:ninety]   / totals[:ninety])   unless totals[:ninety]   == 0.00
      self.attendance_lifetime = (att[:lifetime] / totals[:lifetime]) unless totals[:lifetime] == 0.00
      
      # Loot Factor
      lf = { :lf => 0.00, :sitlf => 0.00, :bislf => 0.00 }
      Item.find(:all, :include => :raid, :conditions => ["member_id = ?", self.id]).each do |i|
      # self.items.each do |i|
        if i.affects_loot_factor?
          if i.situational?
            lf[:sitlf] += i.adjusted_price
          elsif i.best_in_slot?
            lf[:bislf] += i.adjusted_price
          else
            lf[:lf] += i.adjusted_price
          end
        end
      end
      
      unless self.attendance_30 == 0.0
        self.lf    = (lf[:lf]    / self.attendance_30)
        self.sitlf = (lf[:sitlf] / self.attendance_30)
        self.bislf = (lf[:bislf] / self.attendance_30)
      end
      
      self.uncached_updates = 0
      
      # Force is true if we're being called outside of the before_save callback
      # so we have to save manually
      # if force
        # Let's go without validations since we're only updating LF and Attendance
        self.save(false)
      # end
      
      logger.info "update_cache finished on #{self.name} ---------------------"
    end
end
