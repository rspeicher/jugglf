# == Schema Information
#
# Table name: punishments
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  reason     :string(255)
#  expires    :date
#  value      :float           default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Punishment do
  before(:each) do
    @punishment = Factory(:punishment)
    @expired    = Factory(:punishment_expired)
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
    it { should allow_mass_assignment_of(:expires) }
    it { should allow_mass_assignment_of(:expires_string) }
    it { should allow_mass_assignment_of(:value) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  context "validations" do
    it { should validate_presence_of(:reason) }
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:expires) }
    it { should validate_numericality_of(:value) }
  end

  it "should forcibly expire" do
    @punishment.expire!
    @punishment.expires.should_not >= Date.today
  end
end

describe Punishment, "#expires_string" do
  before(:each) do
    Timecop.freeze(Date.today)
    @punishment = Factory(:punishment, :expires => 3.days.since(Date.today))
  end

  it "should set expires date from a string" do
    @punishment.expires_string = 1.year.until(Date.today).to_s
    @punishment.expires.to_date.should eql(1.year.until(Date.today))
  end

  it "should return expires as a string" do
    @punishment.expires_string.should eql(3.days.since(Date.today))
  end

  it "should return a date 52 days from now if expires is not yet set" do
    @punishment.expires = nil
    @punishment.expires_string.should eql(52.days.from_now.to_date)
  end
end

describe Punishment, "callbacks" do
  before(:each) do
    @member = Factory(:member)
    @member.punishments << Factory.build(:punishment, :value => 1.00)
    @member.reload
  end

  it "should update member cache after save" do
    @member.lf.should_not == 0.00
  end

  it "should update member cache after expire!" do
    @member.punishments.find(:last).expire!
    @member.reload
    @member.lf.should eql(0.00)
  end

  it "should update member cache after destroy" do
    Punishment.destroy_all
    @member.reload
    @member.lf.should eql(0.00)
  end
end
