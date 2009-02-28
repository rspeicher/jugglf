# == Schema Information
# Schema version: 20090225185730
#
# Table name: members
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  active              :boolean(1)      default(TRUE)
#  first_raid          :date
#  last_raid           :date
#  raids_count         :integer(4)      default(0)
#  wow_class           :string(255)
#  lf                  :float           default(0.0)
#  sitlf               :float           default(0.0)
#  bislf               :float           default(0.0)
#  attendance_30       :float           default(0.0)
#  attendance_90       :float           default(0.0)
#  attendance_lifetime :float           default(0.0)
#  created_at          :datetime
#  updated_at          :datetime
#  rank_id             :integer(4)
#  items_count         :integer(4)      default(0)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
  before(:each) do
    @member = Member.make
  end
  
  it "should be valid" do
    @member.should be_valid
  end
  
  it "should be active by default" do
    @member.active?.should be_true
  end
  
  it "should have raid attendance" do
    5.times { @member.attendance.make }
    
    @member.reload
    @member.raids_count.should == 5
    @member.raids.size.should == 5
  end
  
  it "should have loot purchases" do
    8.times { @member.loots.make }
    
    @member.reload
    @member.loots_count.should == 8
    @member.loots.size.should == 8
  end
end

describe Member, "attendance caching" do
  before(:each) do
    @member = Member.make
    
    @raids = {
      :yesterday      => Raid.make(:date => 1.day.ago),
      :two_months_ago => Raid.make(:date => 2.months.ago)
    }
    
    Attendee.make(:member => @member, :raid => @raids[:yesterday])
    Attendee.make(:member => @member, :raid => @raids[:two_months_ago])
    
    @member.force_recache!
  end
  
  it "should set first_raid" do
    @member.first_raid.should == @raids[:two_months_ago].date
  end
  
  it "should set last_raid" do
    @member.last_raid.should == @raids[:yesterday].date
  end
  
  it "should update attendance percentages" do
    @member.attendance_30.should_not       == 0.00
    @member.attendance_90.should_not       == 0.00
    @member.attendance_lifetime.should_not == 0.00
  end
  
  it "should update all member cache" do
    @member.attendance.make(:attendance => 0.10)
    @member.reload
    lambda do
      Member.update_all_cache
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
    
    @member.force_recache!
  end
  
  it "should update normal loot factor" do
    @member.lf.should == 1.23
  end
  
  it "should update best in slot loot factor" do
    @member.bislf.should == 4.56
  end
  
  it "should update situational loot factor" do
    @member.sitlf.should == 7.89
  end
end

# -----------------------------------------------------------------------------

describe Member, "punishments" do
  before(:each) do
    @member = Member.make
  end
  
  it "should affect loot factor" do
    @member.punishments.make
    @member.force_recache!
    
    @member.lf.should > 0.0
  end
  
  it "should not include expired punishments" do
    @member.punishments.make(:expired)
    @member.force_recache!
    
    @member.lf.should == 0.0
  end
end

# -----------------------------------------------------------------------------

describe Member, "dependencies" do
  before(:each) do
    [Attendee, Loot, Punishment].each(&:destroy_all)
    @member = Member.make
    
    @member.attendance.make
    @member.loots.make
    @member.punishments.make
    
    @member.destroy
  end
  
  it "should destroy associated attendance" do
    Attendee.count.should == 0
  end
  
  it "should nullify loot purchases" do
    loot = Loot.find(:last)
    loot.member_id.should be_nil
  end
  
  it "should destroy punishments" do
    Punishment.count.should == 0
  end
end

  # describe "with rank" do
  #   before(:each) do
  #     @member = members(:tsigo)
  #     @member.rank = MemberRank.create(:name => 'Officer', :prefix => '<b>', :suffix => '</b>')
  #   end
  # end
