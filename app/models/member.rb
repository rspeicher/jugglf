class Member < ActiveRecord::Base
  has_many :attendees
  has_many :items
  has_many :raids, :through => :attendees  
end
