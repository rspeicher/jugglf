class Raid < ActiveRecord::Base
  has_many :attendees
  has_many :members, :through => :attendees
end
