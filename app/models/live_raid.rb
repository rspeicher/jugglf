# == Schema Information
#
# Table name: live_raids
#
#  id         :integer(4)      not null, primary key
#  started_at :datetime
#  stopped_at :datetime
#

class LiveRaid < ActiveRecord::Base
  attr_accessible nil
  
  has_many :live_loots, :dependent => :destroy
  alias_method :loots, :live_loots
  
  validates_presence_of :started_at, :if => Proc.new { |obj| obj.stopped_at.present? }
  
  # Uses +started_at+ and +stopped_at+ to determine the raid's total running time
  # in minutes (surprise!)
  #
  # If the raid hasn't yet been stopped, this value will update in real time.
  #
  # Example:
  #   Started at Thu Dec 31 22:16:33 -0500 2009
  #   Stopped at Thu Dec 31 23:16:33 -0500 2009
  #   Returns 60
  #
  #   Started at Thu Dec 31 22:16:33 -0500 2009
  #   Stopped at nil
  #   Returns 5, assuming +Time.now+ is Thu Dec 31 22:21:33 -0500 2009
  def running_time_in_minutes
    return 0 if self.started_at.nil? and self.stopped_at.nil?
    
    if self.stopped_at.nil?
      # Raid has not yet been stopped, use the current time
      ((Time.now - self.started_at)/60.0).floor
    else
      ((self.stopped_at - self.started_at)/60.0).floor
    end
  end
  
  # Start a raid
  #
  # Sets the value of +started_at+ to the current time and saves the record. Calling 
  # +start!+ subsequent times will have no effect.
  def start!
    return unless self.started_at.nil?
    
    self.update_attribute(:started_at, Time.now)
  end
  
  # Stop a raid
  #
  # Sets the value of +stopped_at+ to the current time and saves the record. Calling
  # +stop!+ subsequent times, or on an unstarted raid, will have no effect.
  #
  # Any associated +LiveAttendee+ records will also have their +stop!+ method called
  def stop!
    return unless self.started_at.present? and self.stopped_at.nil?
    
    # TODO: Attendees
    
    self.update_attribute(:stopped_at, Time.now)
  end
end
