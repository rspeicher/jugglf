# == Schema Information
# Schema version: 20090213233547
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
#  uncached_updates    :integer(4)      default(0)
#  rank_id             :integer(4)
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
    @member.attendance_30.should_not == 0.00
    @member.attendance_90.should_not == 0.00
  end
end
  
# -----------------------------------------------------------------------------

describe Member, "loot factor caching" do
  before(:each) do
    Raid.destroy_all
    raid   = Raid.make
    
    @member = Member.make
    @member.attendance.make(:raid => raid, :attendance => 1.00)

    @member.items.make(:raid => raid, :price => 1.23)
    @member.items.make(:raid => raid, :price => 4.56, :best_in_slot => true)
    @member.items.make(:raid => raid, :price => 7.89, :situational => true)
    
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
  
describe Member, "incomplete" do
  describe "loot factor caching" do
    before(:all) do
      # Raid.destroy_all # [Member, Raid, Item, Attendee].each(&:delete_all)
      # att = Attendee.make(:attendance => 1.00)
      # @member = att.member
      # 
      # @items = {
      #   :normal => Item.make(:member => @member, :price => 1.23),
      #   :bis    => Item.make(:member => @member, :price => 4.56, :best_in_slot => true),
      #   :sit    => Item.make(:member => @member, :price => 7.89, :situational => true),
      # }
      #   
      # @member.force_recache!
    end
    
    it "should update normal loot factor" do
      # @member.lf.should == 1.23
    end
    
    # it "should update best in slot loot factor" do
    #   @member.bislf.should == 4.56
    # end
    # 
    # it "should update situational loot factor" do
    #   @member.sitlf.should == 7.89
    # end
  end
    
    it "should update cache on existing member" # do
     #      m = members(:update_cache)
     #      m.should_recache?.should be_true
     #    
     #      populate_member_for_caching(m)
     #    
     #      m = Member.find_by_name('UpdateMyCache')
     #      m.attendance_30.should == 1.00
     #      m.attendance_90.should == 0.666667
     #    
     #      m.lf.should    == 5.00
     #      m.sitlf.should == 30.00
     #      m.bislf.should == 3.14
     #    end
  
    it "should update cache on new member" # do
     #      m = Member.new(:name => "NewCache")
     #      m.should_recache?.should_not be_true
     #    
     #      m.save
     #      populate_member_for_caching(m)
     #    
     #      m = Member.find_by_name('NewCache')
     #      m.attendance_30.should == 1.00
     #      m.attendance_90.should == 0.666667
     #    
     #      m.lf.should    == 5.00
     #      m.sitlf.should == 30.00
     #      m.bislf.should == 3.14
     #    end
    
    # def populate_member_for_caching(m)
    #   # Add raid attendance
    #   m.attendance.create(:raid_id => raids(:today).id, :attendance => 1.00)
    #   m.attendance.create(:raid_id => raids(:yesterday).id, :attendance => 1.00)
    #   m.uncached_updates += 2
    # 
    #   # Add an item
    #   m.items.create(:name => 'Normal LF', :price => 5.00, 
    #     :raid_id => raids(:yesterday).id)
    #   m.items.create(:name => 'Sit LF', :price => 30.00, 
    #     :raid_id => raids(:today).id, :situational => true)
    #   m.items.create(:name => 'BiS LF, Not Affected', :price => 10.00, 
    #     :raid_id => raids(:two_months_ago).id, :best_in_slot => true)
    #   m.items.create(:name => 'BiS LF', :price => 3.14, 
    #     :raid_id => raids(:yesterday).id, :best_in_slot => true)
    #   m.items.size.should == 4
    # 
    #   m.save!
    #   m.force_recache!
    # end
  
  # ---------------------------------------------------------------------------

  describe "attending a raid" do
    # fixtures :raids
  
    it "has raid attendance" # do
     #      m = members(:tsigo)
     #      m.attendance.size.should == 0
     #      m.raids << raids(:today)
     #      m.raids << raids(:yesterday)
     #      m.save
     #    
     #      m.attendance.size.should == 2
     #    end
  end
  
  # ---------------------------------------------------------------------------

  describe "purchasing an item" do
    # fixtures :items
  
    it "has an item purchase" # do
     #      m = members(:tsigo)
     #      m.items.size.should == 0
     #    
     #      i = Item.create(:name => 'Warglaive of Azzinoth', :price => 5.00)
     #      m.items << i
     #    
     #      m.items.size.should == 1
     #      m.should == i.buyer
     #    end
  end
  
  # ---------------------------------------------------------------------------
  
  describe "with punishments" do
    # fixtures :punishments
    
    # before(:each) do
    #   @m = members(:punished)
    # end
    
    it "should affect loot factor" # do
     #      @m.punishments << punishments(:late)
     #      @m.force_recache!
     #      
     #      @m.lf.should >= punishments(:late).value
     #    end
    
    it "should not include expired punishments" # do
     #      @m.punishments << punishments(:expired)
     #      @m.force_recache!
     #      
     #      @m.lf.should == 0.0
     #    end
  end
  
  # ---------------------------------------------------------------------------
  
  # describe "with rank" do
  #   before(:each) do
  #     @member = members(:tsigo)
  #     @member.rank = MemberRank.create(:name => 'Officer', :prefix => '<b>', :suffix => '</b>')
  #   end
  # end
end
