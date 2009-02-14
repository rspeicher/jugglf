# == Schema Information
# Schema version: 20090213233547
#
# Table name: punishments
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  reason     :string(255)
#  expires    :date
#  value      :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

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
