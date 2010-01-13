# == Schema Information
#
# Table name: members
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  active              :boolean(1)      default(TRUE)
#  first_raid          :date
#  last_raid           :date
#  wow_class           :string(255)
#  lf                  :float           default(0.0)
#  sitlf               :float           default(0.0)
#  bislf               :float           default(0.0)
#  attendance_30       :float           default(0.0)
#  attendance_90       :float           default(0.0)
#  attendance_lifetime :float           default(0.0)
#  raids_count         :integer(4)      default(0)
#  loots_count         :integer(4)      default(0)
#  created_at          :datetime
#  updated_at          :datetime
#  rank_id             :integer(4)
#  wishlists_count     :integer(4)      default(0)
#  user_id             :integer(4)
#

require 'spec_helper'

describe Member do
  before(:each) do
    @member = Member.make
  end
  
  it "should validate" do
    @member.should be_valid
  end
  
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
  
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).with_message(/already exists/) }
  it { should allow_value(nil).for(:wow_class) }
  it { should allow_value('Priest').for(:wow_class) }
  it { should_not allow_value('Invalid').for(:wow_class) }
  
  it "should have a custom to_param" do
    @member.to_param.should eql("#{@member.id}-#{@member.name.parameterize}")
  end
  
  it "should have a custom to_s" do
    @member.to_s.should eql("#{@member.name}")
  end
end

describe Member, "#lf_type" do
  before(:each) do
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

# -----------------------------------------------------------------------------

describe Member, "#clean_trash" do
  before(:each) do
    @member = Member.make(:active => false, :rank => MemberRank.make(:name => 'Declined Applicant'))
    
    @member.completed_achievements << Factory(:completed_achievement, :member => @member)
    @member.wishlists.make
  end
  
  it "should do nothing if a member is active" do
    @member.active = true
    lambda { @member.save }.should_not change(@member.wishlists, :count)
  end
  
  it "should do nothing if a member is not a declined applicant" do
    @member.rank = nil
    lambda { @member.save }.should_not change(@member.wishlists, :count)
  end
  
  it "should clear completed_achievements for an inactive declined applicant" do
    lambda { @member.save }.should change(@member.completed_achievements, :count).from(1).to(0)
  end
  
  it "should clear wishlists for an inactive declined applicant" do
    lambda { @member.save }.should change(@member.wishlists, :count).to(0)
  end
end

# -----------------------------------------------------------------------------

describe Member, "full attendance caching" do
  before(:each) do
    @member = Member.make
    
    @raids = {
      :yesterday      => Raid.make(:date => 1.day.ago),
      :two_months_ago => Raid.make(:date => 2.months.ago)
    }
    
    Attendee.make(:member => @member, :raid => @raids[:yesterday])
    Attendee.make(:member => @member, :raid => @raids[:two_months_ago])
    
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
    @member.attendance.make(:attendance => 0.10)
    @member.reload
    lambda do
      Member.update_cache(:all)
      @member.reload
    end.should change(@member, :attendance_lifetime)
  end
end
  
# -----------------------------------------------------------------------------

describe Member, "loot factor caching" do
  before(:each) do
    Raid.destroy_all
    raid = Raid.make
    
    @member = Member.make
    @member.attendance.make(:raid => raid, :attendance => 1.00)

    @member.loots.make(:raid => raid, :price => 1.23)
    @member.loots.make(:raid => raid, :price => 4.56, :best_in_slot => true)
    @member.loots.make(:raid => raid, :price => 7.89, :situational => true)
    
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

# -----------------------------------------------------------------------------

describe Member, "punishments" do
  before(:each) do
    @member = Member.make
  end
  
  it "should affect loot factor" do
    @member.punishments << Factory.build(:punishment, :value => 1.00)
    @member.update_cache
    
    @member.lf.should > 0.0
  end
  
  it "should not include expired punishments" do
    @member.punishments << Factory.build(:punishment_expired, :value => 1.00)
    @member.update_cache
    
    @member.lf.should eql(0.0)
  end
end