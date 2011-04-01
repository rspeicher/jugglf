require 'spec_helper'

describe Achievement do
  subject { Factory(:achievement) }

  it { should be_valid }

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
    subject.to_s.should eql(subject.title.to_s)
  end
end
