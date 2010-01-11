# == Schema Information
#
# Table name: achievements
#
#  id          :integer(4)      not null, primary key
#  armory_id   :integer(4)
#  category_id :integer(4)
#  title       :string(255)
#  icon        :string(255)
#

require 'spec_helper'

describe Achievement do
  before(:each) do
    @ach = Factory(:achievement)
  end
  
  it "should be valid" do
    @ach.should be_valid
  end
  
  it { should have_many(:completed_achievements).dependent(:destroy) }
  it { should have_many(:members) }
  
  it { should validate_presence_of(:armory_id) }
  it { should validate_presence_of(:category_id) }
  it { should validate_presence_of(:title) }
  
  it "should have a custom to_s" do
    @ach.to_s.should eql(@ach.title.to_s)
  end
end
