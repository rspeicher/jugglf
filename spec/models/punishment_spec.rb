# == Schema Information
#
# Table name: punishments
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  reason     :string(255)
#  expires_on :date
#  value      :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Punishment do
  before(:each) do
    @punishment = Factory(:punishment)
    @expired    = Factory(:expired_punishment)
  end

  it "should be valid" do
    @punishment.should be_valid
  end

  context "associations" do
    it { should belong_to(:member) }
  end

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:member_id) }
    it { should allow_mass_assignment_of(:reason) }
    it { should allow_mass_assignment_of(:expires_on) }
    it { should allow_mass_assignment_of(:expires_on_string) }
    it { should allow_mass_assignment_of(:value) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  context "validations" do
    it { should validate_presence_of(:reason) }
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:expires_on) }
    it { should validate_numericality_of(:value) }
  end

  it "should forcibly expire" do
    @punishment.expire!
    @punishment.expires_on.should_not >= Date.today
  end
end

describe Punishment, "#expires_on_string" do
  before(:each) do
    Timecop.freeze(Date.today)
    @punishment = Factory(:punishment, :expires_on => 3.days.since(Date.today))
  end

  it "should set expires_on date from a string" do
    @punishment.expires_on_string = 1.year.until(Date.today).to_s
    @punishment.expires_on.to_date.should eql(1.year.until(Date.today))
  end

  it "should return expires_on as a string" do
    @punishment.expires_on_string.should eql(3.days.since(Date.today))
  end

  it "should return a date 52 days from now if expires_on is not yet set" do
    @punishment.expires_on = nil
    @punishment.expires_on_string.should eql(52.days.from_now.to_date)
  end
end

describe Punishment, "#active?" do
  it "should return true for an active punishment" do
    Factory(:punishment).active?.should be_true
  end

  it "should should return false for an inactive punishment" do
    Factory(:expired_punishment).active?.should be_false
  end
end

describe Punishment, "callbacks" do
  before(:each) do
    @member = Factory(:member)
    @member.should_receive(:update_cache).once.and_return(true)
  end

  it "should update member cache after save" do
    Factory(:punishment, :member => @member, :value => 1.00)
  end

  it "should update member cache after expire!" do
    Factory.build(:punishment, :member => @member, :value => 1.00).expire!
  end

  it "should update member cache after destroy" do
    Factory(:punishment, :member => @member, :value => 1.00)
    Punishment.last.destroy
  end
end
