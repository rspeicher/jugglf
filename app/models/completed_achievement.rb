class CompletedAchievement < ActiveRecord::Base
  belongs_to :achievement
  belongs_to :member
end
