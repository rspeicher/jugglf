# == Schema Information
# Schema version: 20090213233547
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
#

class Raid < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_many :attendees
  has_many :items, :order => "items.name ASC"
  has_many :members, :through => :attendees, :order => "name ASC"
  
  # Attributes ----------------------------------------------------------------
  attr_accessor :update_attendee_cache
  attr_accessor :attendance_output
  attr_accessor :loot_output
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :date
  
  # Callbacks -----------------------------------------------------------------
  after_create [ :populate_attendees, :populate_drops ]
  after_update [ :populate_attendees, :populate_drops ]
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
  
  def date_string
    ( self.date.nil? ) ? Date.today.to_s : self.date.to_s(:db)
  end
  def date_string=(value)
    self.date = Time.parse(value)
  end
  
  private
    def populate_attendees
      # TODO: Do we self.attendees.destroy_all during an after_update call?
      return if @attendance_output.nil? or @attendance_output.empty?
      
      require 'csv'
      lines = CSV.parse(@attendance_output) do |line|
        next if line[0].nil? or line[0].strip.empty?
        
        m = Member.find_or_initialize_by_name(line[0].strip)
        m.uncached_updates += 1
        m.save

        begin
          self.attendees.create(:member_id => m.id, :attendance => line[1])
        rescue ActiveRecord::StatementInvalid => e
          # Probably a duplicate entry error caused by having the same member
          # twice or more in the output; find the member by id and then
          # see which attendance value is lower and use that
          a = self.attendees.find_by_member_id(m.id)
          if not a.nil? and line[1].to_f < a.attendance
            a.attendance = line[1]
            a.save
          end # lower attendance
        end # rescue
      end #CSV.parse
    end
    
    def populate_drops
      return if @loot_output.nil? or @loot_output.empty?
      
      lines = @loot_output.split("\n")
      lines.each do |line|
        items = Item.from_attendance_output(line)

        if items and items.length > 0
          items.each do |item|
            item.save!

            self.items << item
          end
        end
      end
    end
    
    def update_cache
      # We have to update all members' cache, because if a member didn't attend
      # this raid, it should still affect that person's attendance percentages
      Member.update_all_cache unless @update_attendee_cache == false
    end
end
