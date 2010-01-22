# == Schema Information
#
# Table name: attendees
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  raid_id    :integer(4)
#  attendance :float
#

class Attendee < ActiveRecord::Base
  attr_accessible :member, :member_id, :raid, :raid_id, :attendance

  belongs_to :member, :counter_cache => :raids_count
  belongs_to :raid, :counter_cache => true

  validates_presence_of :member
  validates_presence_of :raid

  def to_s
    "#{self.member.name} on #{self.raid.date}"
  end
end
