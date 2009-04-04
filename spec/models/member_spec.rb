# == Schema Information
# Schema version: 20090312150316
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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Member do
  before(:each) do
    @member = Member.make
  end
  
  it "should be valid" do
    @member.should be_valid
  end
  
  it "should have custom to_param" do
    @member.to_param.should == "#{@member.id}-#{@member.name.parameterize}"
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
  
  describe "#lf_type" do
    before(:each) do
      @member.lf    = 1.23
      @member.bislf = 4.56
      @member.sitlf = 7.89
    end
    it "should return normal LF for rot" do
      @member.lf_type(:rot).should == @member.lf
    end
    
    it "should return normal LF" do
      @member.lf_type(:normal).should == @member.lf
    end
    
    it "should return best in slot LF" do
      @member.lf_type(:bis).should == @member.bislf
    end
    
    it "should return situational LF" do
      @member.lf_type(:sit).should == @member.sitlf
      @member.lf_type(:situational).should == @member.sitlf
    end
    
    it "should take a string" do
      @member.lf_type('best in slot').should == @member.bislf
    end
  end
end

# -----------------------------------------------------------------------------

describe Member, "#clean_trash" do
  before(:each) do
    @declined = MemberRank.make(:name => 'Declined Applicant')
    @member = Member.make(:active => false, :rank => @declined)
    
    3.times { @member.completed_achievements.make }
    4.times { @member.wishlists.make }
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
    lambda { @member.save }.should change(@member.completed_achievements, :count).to(0)
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
    @member.update_cache
    
    @member.lf.should > 0.0
  end
  
  it "should not include expired punishments" do
    @member.punishments.make(:expired)
    @member.update_cache
    
    @member.lf.should == 0.0
  end
end

# -----------------------------------------------------------------------------

describe Member, "dependencies" do
  before(:each) do
    [Attendee, Loot, Punishment, Wishlist].each(&:destroy_all)
    @member = Member.make
    
    @member.attendance.make
    @member.loots.make
    @member.punishments.make
    @member.wishlists.make
    
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
  
  it "should destroy wishlists" do
    Wishlist.count.should == 0
  end
end

  # describe "with rank" do
  #   before(:each) do
  #     @member = members(:tsigo)
  #     @member.rank = MemberRank.create(:name => 'Officer', :prefix => '<b>', :suffix => '</b>')
  #   end
  # end
