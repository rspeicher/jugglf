class Punishment < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  belongs_to :member
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :reason
  validates_presence_of :value
  validates_presence_of :expires
  
  def expire!
    self.expires = 1.day.ago.to_s(:db)
    self.save!
    self.member.force_recache! if self.member
  end
end
