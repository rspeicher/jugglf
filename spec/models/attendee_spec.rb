require 'spec_helper'

describe Attendee do
  subject { Factory(:attendee) }

  it { should be_valid }

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should allow_mass_assignment_of(:member) }
    it { should allow_mass_assignment_of(:member_id) }
    it { should allow_mass_assignment_of(:raid) }
    it { should allow_mass_assignment_of(:raid_id) }
    it { should allow_mass_assignment_of(:attendance) }
  end

  context "associations" do
    it { should belong_to(:member) }
    it { should belong_to(:raid) }
  end

  context "validations" do
    it { should validate_presence_of(:member) }
    it { should validate_presence_of(:raid) }
  end

  it "should have a custom to_s" do
    subject.to_s.should eql("#{subject.member.name} on #{subject.raid.date}")
  end
end
