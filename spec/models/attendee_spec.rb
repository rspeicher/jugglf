require 'spec_helper'

describe Attendee do
  before(:each) do
    @attendee = Factory(:attendee)
  end

  it "should be valid" do
    @attendee.should be_valid
  end

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
    @attendee.to_s.should eql("#{@attendee.member.name} on #{@attendee.raid.date}")
  end
end
