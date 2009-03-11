class Achievement < ActiveRecord::Base
  has_many :completed_achievements, :include => :member, :dependent => :destroy
  has_many :members, :through => :completed_achievements
end
