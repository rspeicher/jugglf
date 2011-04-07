class Punishment < ActiveRecord::Base
  attr_accessible :reason, :expires_on, :expires_on_string, :value

  belongs_to :member

  validates_presence_of :reason
  validates_presence_of :value
  validates_presence_of :expires_on
  validates_numericality_of :value

  scope :active, lambda { where("expires_on > ?", Date.today) }

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
end
