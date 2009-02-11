# == Schema Information
# Schema version: 20090208213027
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
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :date
  
  # Callbacks -----------------------------------------------------------------
  after_create :populate_attendees
  after_update :populate_attendees
  after_save :update_attendee_cache
  
  # Class Methods -------------------------------------------------------------
  def self.count_last_thirty_days
    Raid.count(:conditions => [ "date >= ?", 30.days.ago ])
  end
  def self.count_last_ninety_days
    Raid.count(:conditions => [ "date >= ?", 90.days.ago ])
  end
  
  # Instance Methods ----------------------------------------------------------
  def is_in_last_thirty_days?
    self.date >= 30.days.ago.to_datetime
  end
  def is_in_last_ninety_days?
    self.date >= 90.days.ago.to_datetime
  end
  
  # def attendance_output
  #    require 'csv'
  #    out = ""
  #    
  #    CSV::Writer.generate(out) do |csv|
  #      self.attendees.each do |a|
  #        csv << [ a.member.name, a.attendance ]
  #      end
  #    end
  #    
  #    out
  # end
  # def attendance_output=(value)
  # end
  
  def loot_output
  end
  def loot_output=(value)
    lines = value.split("\n")
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
  
  private
    def populate_attendees
      # TODO: Do we self.attendees.destroy_all during an after_update call?
      return if @attendance_output.nil? or @attendance_output.empty?
      
      require 'csv'
      lines = CSV.parse(@attendance_output) do |line|
        unless line[0].nil? or line[0].strip.empty?
          m = Member.find_or_initialize_by_name(line[0])
          m.uncached_updates += 1

          if m.save
            self.attendees.create(:member_id => m.id, :attendance => line[1])
          end
        end
      end
    end
    
    def update_attendee_cache
      Member.update_all_cache unless @update_attendee_cache == false
    end
end
