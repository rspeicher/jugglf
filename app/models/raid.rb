# == Schema Information
# Schema version: 20090224005026
#
# Table name: raids
#
#  id              :integer(4)      not null, primary key
#  date            :date
#  note            :string(255)
#  thread          :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  attendees_count :integer(4)      default(0)
#  items_count     :integer(4)      default(0)
#

class Raid < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_many :attendees, :dependent => :destroy
  has_many :items, :order => "items.name ASC", :dependent => :destroy
  has_many :members, :through => :attendees, :order => "name ASC"
  
  # Attributes ----------------------------------------------------------------
  attr_accessor :update_attendee_cache
  attr_accessor :attendance_output
  attr_accessor :loot_output
  
  attr_accessible :date, :note, :thread
  
  def date_string
    ( self.date.nil? ) ? Date.today.to_s : self.date.to_s(:db)
  end
  def date_string=(value)
    self.date = Time.parse(value)
  end
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :date
  
  # Callbacks -----------------------------------------------------------------
  after_create [ :parse_attendees, :parse_drops ]
  after_update [ :parse_attendees, :parse_drops ]
  after_save :update_cache
  after_destroy :update_cache
  
  # Class Methods -------------------------------------------------------------
  def self.count_last_thirty_days
    Raid.count(:conditions => [ "date >= ?", 30.days.until(Date.today) ])
  end
  def self.count_last_ninety_days
    Raid.count(:conditions => [ "date >= ?", 90.days.until(Date.today) ])
  end
  
  # Instance Methods ----------------------------------------------------------
  def is_in_last_thirty_days?
    self.date >= 30.days.until(Date.today)
  end
  def is_in_last_ninety_days?
    self.date >= 90.days.until(Date.today)
  end
  
  private
    def parse_attendees
      return if @attendance_output.nil? or @attendance_output.empty?
      
      attendees = Juggy.parse_attendees(@attendance_output)
      return if attendees.nil? or attendees.size == 0
      
      attendees.each do |att|
        member = Member.find_or_initialize_by_name(att[:name])
        
        begin
          self.attendees.create(:member => member, :attendance => att[:attendance])
        rescue ActiveRecord::StatementInvalid => e
          # Probably a duplicate entry error caused by having the same member
          # twice or more in the output; find the member by name and then
          # see which attendance value is lower and use that
          existing = self.attendees.find_by_member_id(member.id)
          if not existing.nil? and att[:attendance] < existing.attendance
            existing.attendance = att[:attendance]
            existing.save
          end
        end
      end
    end
    
    def parse_drops
      return if @loot_output.nil? or @loot_output.empty?
      
      items = Juggy.parse_items(@loot_output)
      return if items.nil? or items.size == 0
      
      items.each do |params|
        self.items.create(params)
      end
    end
    
    def update_cache
      # We have to update all members' cache, because if a member didn't attend
      # this raid, it should still affect that person's attendance percentages
      Member.update_all_cache unless @update_attendee_cache == false
    end
end
