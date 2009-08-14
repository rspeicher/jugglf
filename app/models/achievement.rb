class Achievement < ActiveRecord::Base
  has_many :completed_achievements, :dependent => :destroy
  has_many :members, :through => :completed_achievements
end
