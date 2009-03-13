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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CompletedAchievement do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    CompletedAchievement.create!(@valid_attributes)
  end
end
