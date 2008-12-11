class Attendee < ActiveRecord::Base
  belongs_to :member
  belongs_to :raid
  
  def to_s
    attendance.to_s
  end
end
