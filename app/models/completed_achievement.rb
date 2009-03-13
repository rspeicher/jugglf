# == Schema Information
# Schema version: 20090312150316
#
# Table name: completed_achievements
#
#  id             :integer(4)      not null, primary key
#  member_id      :integer(4)
#  achievement_id :integer(4)
#  completed_on   :date
#

class CompletedAchievement < ActiveRecord::Base
  belongs_to :achievement
  belongs_to :member
end
