# == Schema Information
# Schema version: 20090112080555
#
# Table name: raids
#
#  id         :integer(4)      not null, primary key
#  date       :date
#  note       :string(255)
#  thread     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Raid < ActiveRecord::Base
  has_many :attendees
  has_many :items
  has_many :members, :through => :attendees
end
