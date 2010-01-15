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
  
  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should allow_mass_assignment_of(:armory_id) }
    it { should allow_mass_assignment_of(:category_id) }
    it { should allow_mass_assignment_of(:title) }
    it { should allow_mass_assignment_of(:icon) }
  end
  
  context "associations" do
    it { should have_many(:completed_achievements).dependent(:destroy) }
    it { should have_many(:members) }
  end
  
  context "validations" do
    it { should validate_presence_of(:armory_id) }
    it { should validate_presence_of(:category_id) }
    it { should validate_presence_of(:title) }
  end
  
  it "should have a custom to_s" do
    @ach.to_s.should eql(@ach.title.to_s)
  end
end
