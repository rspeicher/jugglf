# == Schema Information
#
# Table name: punishments
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  reason     :string(255)
#  expires_on :date
#  value      :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

class Punishment < ActiveRecord::Base
  attr_accessible :reason, :expires_on, :expires_on_string, :value

  belongs_to :member

  validates_presence_of :reason
  validates_presence_of :value
  validates_presence_of :expires_on
  validates_numericality_of :value

  named_scope :active, :conditions => ['expires_on > ?', Date.today]

  after_save    :update_member_cache
  after_destroy :update_member_cache

  def expires_on_string
    # Default to 52 days from now so that it acts as a normal loot item
    ( self.expires_on.nil? ) ? 52.days.from_now.to_date : self.expires_on.to_date
  end
  def expires_on_string=(value)
    self.expires_on = Time.parse(value)
  end

  # Immediately expire a punishment. Saves the record.
  def expire!
    self.expires_on = 24.hours.until(Date.today)
    self.save!
  end

  # Determines if the punishment has expired or not
  def active?
    self.expires_on > Date.today
  end

  private
    def update_member_cache
      self.member.update_cache unless self.member_id.nil?
    end
end
