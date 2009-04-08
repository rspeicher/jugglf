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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Achievement do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Achievement.create!(@valid_attributes)
  end
end
