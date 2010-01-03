# == Schema Information
#
# Table name: members
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  active              :boolean(1)      default(TRUE)
#  first_raid          :date
#  last_raid           :date
#  wow_class           :string(255)
#  lf                  :float           default(0.0)
#  sitlf               :float           default(0.0)
#  bislf               :float           default(0.0)
#  attendance_30       :float           default(0.0)
#  attendance_90       :float           default(0.0)
#  attendance_lifetime :float           default(0.0)
#  raids_count         :integer(4)      default(0)
#  loots_count         :integer(4)      default(0)
#  created_at          :datetime
#  updated_at          :datetime
#  rank_id             :integer(4)
#  wishlists_count     :integer(4)      default(0)
#  user_id             :integer(4)
#

class Member < ActiveRecord::Base
  WOW_CLASSES = ['Death Knight'] + (%w(Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior)).freeze
  
  # Relationships -------------------------------------------------------------
  has_many :achievements, :through => :completed_achievements

  has_many :attendees, :dependent => :destroy
  alias_method :attendance, :attendees
  
  has_many :completed_achievements, :include => :achievement, :dependent => :destroy
  
  has_many :loots, :order => "purchased_on DESC", :dependent => :nullify
  has_one :last_loot, :class_name => "Loot", :order => 'purchased_on DESC'
  
  has_many :punishments, :dependent => :destroy
  
  has_many :raids, :through => :attendees, :order => "date DESC"
  
  belongs_to :rank, :class_name => "MemberRank", :foreign_key => "rank_id"

  belongs_to :user

  has_many :wishlists, :include => :item, :order => 'priority', :dependent => :destroy
  
  # Attributes ----------------------------------------------------------------
  attr_accessible :name, :active, :wow_class, :user_id, :rank_id
  searchify :name, :wow_class
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :name
  validates_uniqueness_of :name, :message => "{{value}} already exists"
  validates_format_of :name, :with => /^\w+$/, :message => "{{value}} is not a valid member name"
  validates_inclusion_of :wow_class, :in => WOW_CLASSES, :message => "{{value}} is not a valid WoW class", :allow_nil => true
  
  # Callbacks -----------------------------------------------------------------
  before_save :clean_trash
  
  # Class Methods -------------------------------------------------------------
  def self.update_cache(type = :loot_factor)
    Member.active.each { |m| m.update_cache(type) }
  end
  
  named_scope :active, :order => 'name', :conditions => ['active = ?', true]
  named_scope :with_class, :conditions => 'wow_class IS NOT NULL'
  
  # Instance Methods ----------------------------------------------------------
  def update_cache(type = :loot_factor)
    update_loot_factor_cache()
    update_attendance_cache() if type == :all
    
    self.save
  end
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
  def to_s
    "#{self.name}"
  end
  
  # Takes a string or symbol representing a type of loot factor and returns the
  # corresponding value
  def lf_type(type)
    type = type.downcase.gsub(' ', '_').intern if type.class == String
    
    case type
    when :normal
      retval = self.lf
    when :rot
      retval = self.lf
    when :best_in_slot
      retval = self.bislf
    when :bis
      retval = self.bislf
    when :situational
      retval = self.sitlf
    when :sit
      retval = self.sitlf
    end
  end
  
  private
    # Updates cache for attendance values which DO NOT affect loot factor.
    #
    # 30-day attendance is calculated by @update_loot_factor_cache@ because it
    # is the only attendance value that affects loot factor. Since the other
    # values are non-critical, we can delay updating them to once a day so that
    # cache updates more quickly after a raid or item is added/updated.
    def update_attendance_cache
      # Total possible attendance totals
      totals = {
        :ninety   => Raid.count_last_ninety_days * 1.00,
        :lifetime => nil
      }
      
      # My attendance totals
      att = { :ninety => 0.00, :lifetime => 0.00 }
      Attendee.find(:all, :include => :raid, :conditions => ["member_id = ? AND attendance > 0", self.id]).each do |a|
        self.first_raid = (self.first_raid.nil?) ? a.raid.date : [self.first_raid, a.raid.date].min
        self.last_raid  = (self.last_raid.nil?)  ? a.raid.date : [self.last_raid, a.raid.date].max
        
        if totals[:ninety] > 0.00 and a.raid.is_in_last_ninety_days?
          att[:ninety] += a.attendance
        end
        
        att[:lifetime] += a.attendance
      end
      
      # We can only count lifetime now that first_raid and last_raid were set above
      totals[:lifetime] = Raid.count(:conditions => ["date >= ? AND date <= ?", self.first_raid, self.last_raid]) * 1.00
      
      self.attendance_90       = (att[:ninety]   / totals[:ninety])   unless totals[:ninety]   == 0.00
      self.attendance_lifetime = (att[:lifetime] / totals[:lifetime]) unless totals[:lifetime] == 0.00
    end
    
    def update_loot_factor_cache
      # Update 30-day attendance here instead of in update_attendance_cache for
      # faster cache updates
      
      # Total possible attendance totals
      total = Raid.count_last_thirty_days * 1.00
      
      # My attendance totals
      if total > 0.00
        att = 0.00
        Attendee.find(:all, :include => :raid, :conditions => ["member_id = ? AND #{Raid.table_name}.date >= ?", self.id, 30.days.until(Date.today)]).each do |a|
          att += a.attendance
        end
        
        self.attendance_30 = (att / total)
      end
      
      lf = { :lf => 0.00, :sitlf => 0.00, :bislf => 0.00 }
      
      # Items affecting loot factors
      self.loots.each do |i|
        if i.affects_loot_factor? and not i.adjusted_price.nil?
          if i.situational?
            lf[:sitlf] += i.adjusted_price
          elsif i.best_in_slot?
            lf[:bislf] += i.adjusted_price
          else
            lf[:lf] += i.adjusted_price
          end
        end
      end
      
      # Punishments affect ALL loot factors
      today = Date.today
      self.punishments.each do |p|
        if p.expires > today
          lf[:sitlf] += p.value
          lf[:bislf] += p.value
          lf[:lf]    += p.value
        end
      end
      
      denom = ( self.attendance_30 == 0.0 ) ? 0.01 : self.attendance_30
      self.lf    = (lf[:lf]    / denom)
      self.sitlf = (lf[:sitlf] / denom)
      self.bislf = (lf[:bislf] / denom)
    end
    
    # Once a member is marked as both inactive and a Declined Applicant, we no
    # longer care about a few of their child entries
    def clean_trash
      return unless self.active? == false and self.rank === MemberRank.find_by_name('Declined Applicant')
      
      # Don't care about what they want
      self.wishlists.destroy_all
      
      # Don't care about the achievements they mooched from us
      self.completed_achievements.destroy_all
    end
end
