# == Schema Information
#
# Table name: live_attendees
#
#  id               :integer(4)      not null, primary key
#  member_name      :string(255)     not null
#  live_raid_id     :integer(4)
#  started_at       :datetime
#  stopped_at       :datetime
#  active           :boolean(1)
#  minutes_attended :integer(4)      default(0)
#

class LiveAttendee < ActiveRecord::Base
  attr_accessible :member_name, :live_raid_id
  
  belongs_to :live_raid, :counter_cache => true
  
  validates_presence_of :member_name
  validates_uniqueness_of :member_name, :scope => :live_raid_id
  
  # Calls <tt>stop!</tt> if +active+ is true, or <tt>start!</tt> if not.
  def toggle!
    if self.active?
      self.stop!
    else
      self.start!
    end
  end
  
  def start
    # Don't need to do anything if we're already active or started
    return nil if self.active? and self.started_at.present?
    
    self.started_at = Time.now
    self.active     = true
  end
  def start!
    self.save if self.start
  end
  
  def stop!
    # Don't need to stop unless we're active
    return nil unless self.active? and self.started_at.present?
    
    self.stopped_at = Time.now
    self.active     = false
    
    # Give credit for time attended, adding to any we already have
    self.minutes_attended += ((self.stopped_at - self.started_at)/60).floor
    
    # Set started_at to nil so that if we get started again, we can calculate minutes attended from then on
    self.started_at = nil
    
    self.save
  end
  
  # Returns the number of minutes an attendee has been +active+
  #
  # Because +minutes_attended+ isn't updated until <tt>stop!</tt> is called, inspecting
  # that property while a raid was running would give inaccurate data.
  #
  # +active_minutes+ takes into account the current time as well as any already-
  # accumulated +minutes_attended+.
  #
  # Example:
  # - An attendee has been active since the start of a raid that began one hour ago.
  #   Their +minutes_attended+ attribute would be 0, but +active_minutes+ would be 60.
  # - An attendee was active in the same raid for 30 minutes, and then left for the night.
  #   Both their +minutes_attended+ and +active_minutes+ would be 30.
  # - An attendee was active in the same raid for 10 minutes, left for 20 minutes, and then came back.
  #   Their +minutes_attended+ would be 10, but +active_minutes+ would be 50.
  def active_minutes
    return self.minutes_attended if self.started_at.nil?
    
    if self.active?
      # If we're active, we need to use the last known started_at as well as
      # adding any existing minutes_attended (in case they were stopped and then
      # restarted)
      self.minutes_attended + ((Time.now - self.started_at)/60).floor
    else
      self.minutes_attended
    end
  end
    
  # Takes a comma-separated string of text and creates instances of +LiveAttendee+ objects.
  #
  # For example, passing in the following text...
  #
  #   Tsigo,Duskshadow, Sebudai, Baud,Souai,Tsigo,Tsigo
  #
  # ...will return an array with the following *unsaved* objects
  #
  #   #<LiveAttendee id: nil, member_name: "Tsigo",      live_raid_id: nil, started_at: nil, stopped_at: nil, active: true, minutes_attended: 0>
  #   #<LiveAttendee id: nil, member_name: "Duskshadow", live_raid_id: nil, started_at: nil, stopped_at: nil, active: true, minutes_attended: 0>
  #   #<LiveAttendee id: nil, member_name: "Sebudai",    live_raid_id: nil, started_at: nil, stopped_at: nil, active: true, minutes_attended: 0>
  #   #<LiveAttendee id: nil, member_name: "Baud",       live_raid_id: nil, started_at: nil, stopped_at: nil, active: true, minutes_attended: 0>
  #   #<LiveAttendee id: nil, member_name: "Souai",      live_raid_id: nil, started_at: nil, stopped_at: nil, active: true, minutes_attended: 0>
  #
  # Note that the space after the comma is optional, and that any duplicates are ignored.
  def self.from_text(input)
    retval = []
    return retval unless input.present?
    
    # Build a unique array of our given attendees
    attendees = input.gsub(/[^\w\,]/, '').split(',')
    attendees = attendees.uniq
    
    attendees.each do |attendee|
      retval << self.new(:member_name => attendee.titlecase)
    end
    
    retval
  end
end
