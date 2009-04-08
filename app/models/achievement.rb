# == Schema Information
# Schema version: 20090404033151
#
# Table name: achievements
#
#  id          :integer(4)      not null, primary key
#  armory_id   :integer(4)
#  category_id :integer(4)
#  title       :string(255)
#  icon        :string(255)
#

class Achievement < ActiveRecord::Base
  has_many :completed_achievements, :dependent => :destroy
  has_many :members, :through => :completed_achievements
end
