require 'spec_helper'

describe Member do
  subject { Factory(:member) }

  it { should be_valid }

  context "mass assignment" do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:active) }
    it { should_not allow_mass_assignment_of(:first_raid) }
    it { should_not allow_mass_assignment_of(:last_raid) }
    it { should allow_mass_assignment_of(:wow_class) }
    it { should_not allow_mass_assignment_of(:lf) }
    it { should_not allow_mass_assignment_of(:sitlf) }
    it { should_not allow_mass_assignment_of(:bislf) }
    it { should_not allow_mass_assignment_of(:attendance_30) }
    it { should_not allow_mass_assignment_of(:attendance_90) }
    it { should_not allow_mass_assignment_of(:attendance_lifetime) }
    it { should_not allow_mass_assignment_of(:raids_count) }
    it { should_not allow_mass_assignment_of(:loots_count) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
    it { should allow_mass_assignment_of(:rank_id) }
    it { should_not allow_mass_assignment_of(:wishlists_count) }
    it { should allow_mass_assignment_of(:user_id) }
  end

  context "associations" do
    it { should have_many(:achievements).through(:completed_achievements) }
    it { should have_many(:attendees).dependent(:destroy) }
    it { should have_many(:completed_achievements).dependent(:destroy) }
    it { should have_many(:loots).dependent(:nullify) }
    it { should have_one(:last_loot) }
    it { should have_many(:punishments).dependent(:destroy) }
    it { should have_many(:raids).through(:attendees) }
    it { should belong_to(:rank) }
    it { should belong_to(:user) }
    it { should have_many(:wishlists).dependent(:destroy) }
  end

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).with_message(/already exists/) }
    it { should allow_value(nil).for(:wow_class) }
    it { should allow_value('Priest').for(:wow_class) }
    it { should_not allow_value('Invalid').for(:wow_class) }
  end

  it "should have a custom to_param" do
    subject.to_param.should eql("#{subject.id}-#{subject.name.parameterize}")
  end

  it "should have a custom to_s" do
    subject.to_s.should eql("#{subject.name}")
  end
end

describe Member, "#lf_type" do
  before do
    @member = Factory(:member, :lf => 1.0, :bislf => 2.0, :sitlf => 3.0)
  end

  it "should return normal LF for rot" do
    @member.lf_type(:rot).should eql(1.0)
  end

  it "should return normal LF" do
    @member.lf_type(:normal).should eql(1.0)
  end

  it "should return best in slot LF" do
    @member.lf_type(:bis).should eql(2.0)
  end

  it "should return situational LF" do
    @member.lf_type(:sit).should eql(3.0)
    @member.lf_type(:situational).should eql(3.0)
  end

  it "should take a string" do
    @member.lf_type('best in slot').should eql(2.0)
  end
end

describe Member, "#clean_trash" do
  before do
    @member = Factory(:declined_applicant)
    Factory(:wishlist, :member => @member)
    Factory(:completed_achievement, :member => @member)
  end

  it "should do nothing if a member is active or not a declined applicant" do
    lambda { @member.save }.should_not change(@member.wishlists, :count)
  end

  it "should clear completed_achievements for an inactive declined applicant" do
    lambda {
      @member.active = false
      @member.save
    }.should change(@member.completed_achievements, :count).from(1).to(0)
  end

  it "should clear wishlists for an inactive declined applicant" do
    lambda {
      @member.active = false
      @member.save
    }.should change(@member.wishlists, :count).from(1).to(0)
  end
end

describe Member, "full attendance caching" do
  before do
    Timecop.freeze(Date.today)

    @member = Factory(:member)

    @raids = {
      :yesterday      => Factory(:raid, :date => 1.day.until(Date.today)),
      :two_months_ago => Factory(:raid, :date => 2.months.until(Date.today))
    }

    Factory(:attendee, :member => @member, :raid => @raids[:yesterday])
    Factory(:attendee, :member => @member, :raid => @raids[:two_months_ago])

    @member.update_cache(:all)
  end

  it "should set first_raid" do
    @member.first_raid.should eql(@raids[:two_months_ago].date)
  end

  it "should set last_raid" do
    @member.last_raid.should eql(@raids[:yesterday].date)
  end

  it "should update attendance percentages" do
    @member.attendance_30.should_not       eql(0.00)
    @member.attendance_90.should_not       eql(0.00)
    @member.attendance_lifetime.should_not eql(0.00)
  end

  it "should update all member cache" do
    Factory(:attendee, :member => @member, :attendance => 0.10)
    lambda {
      Member.update_cache(:all)
      @member.reload
    }.should change(@member, :attendance_lifetime)
  end
end

describe Member, "loot factor caching" do
  before do
    raid = Factory(:raid)

    @member = Factory(:member)
    Factory(:attendee, :raid => raid, :member => @member, :attendance => 1.00)

    @member.loots << Factory.build(:loot, :raid => raid, :price => 1.23)
    @member.loots << Factory.build(:loot, :raid => raid, :price => 4.56, :best_in_slot => true)
    @member.loots << Factory.build(:loot, :raid => raid, :price => 7.89, :situational => true)

    @member.update_cache
  end

  it "should update normal loot factor" do
    @member.lf.should eql(1.23)
  end

  it "should update best in slot loot factor" do
    @member.bislf.should eql(4.56)
  end

  it "should update situational loot factor" do
    @member.sitlf.should eql(7.89)
  end
end

describe Member, "punishments" do
  before do
    @member = Factory(:member)
  end

  it "should affect loot factor" do
    @member.punishments << Factory.build(:punishment, :member_id => @member.id, :value => 1.00)
    lambda { @member.update_cache }.should change(@member, :lf).by_at_least(1.00)
  end

  it "should not include expired punishments" do
    @member.punishments << Factory.build(:expired_punishment, :member_id => @member.id, :value => 1.00)
    lambda { @member.update_cache }.should_not change(@member, :lf)
  end
end
