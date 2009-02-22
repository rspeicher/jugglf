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
    # @member = Member.make
  end
  
  it "should allow nil wow_class" do
    member = Member.make(:wow_class => nil)
    member.should be_valid
  end
  
  it "should validate wow_class" # do
   #    m = Member.new(:name => "EverQuest", :wow_class => "Necromancer")
   #    m.should_not be_valid
   #    m.errors.on(:wow_class).should_not be_empty
   #  end

  it "should require a name" # do
   #    m = Member.new
   #    m.should_not be_valid
   #    m.errors.on(:name).should_not be_empty
   #  end
  
  it "should invalidate duplicate names" # do
   #    Member.create(:name => 'Unique')
   #    
   #    m = Member.create(:name => 'Unique')
   #    m.should_not be_valid
   #    m.errors.on(:name).should_not be_empty
   #    
   #    m.name = 'Unique2'
   #    m.save
   #    m.should be_valid
   #  end
  
  it "should be active by default" # do
   #    Member.create(:name => 'New Member')
   #    
   #    m = Member.find(:last)
   #    m.name.should == 'New Member'
   #    m.active?.should be_true
   #  end
  
  # ---------------------------------------------------------------------------

  describe "caching" do
    # fixtures :items, :raids
    
    it "should not recache with a recent updated_at" # do
     #      members(:tsigo).should_recache?.should_not be_true
     #    end

    it "should recache with an outdated updated_at" # do
     #      members(:sebudai).should_recache?.should be_true
     #    end

    it "should recache when uncached_updates is beyond the threshold" # do
     #      m = members(:tsigo)
     #      m.uncached_updates = Member::CACHE_FLUSH
     #      m.should_recache?.should be_true
     #    end
    
    it "should set first_raid" # do
     #      m = Member.create(:name => 'FirstRaid')
     #      m.attendance.create(:raid_id => raids(:today).id, :attendance => 1.00)
     #      m.attendance.create(:raid_id => raids(:two_months_ago).id, :attendance => 1.00)
     #      m.force_recache!
     #      
     #      m.first_raid.should == raids(:two_months_ago).date
     #    end
    
    it "should set last_raid" # do
     #      m = Member.create(:name => 'LastRaid')
     #      m.attendance.create(:raid_id => raids(:two_months_ago).id, :attendance => 1.00)
     #      m.attendance.create(:raid_id => raids(:yesterday).id, :attendance => 1.00)
     #      m.force_recache!
     #      
     #      m.last_raid.should == raids(:yesterday).date
     #    end
    
    it "should not calculate lifetime attendance as greater than 100%" # do
     #      Raid.destroy_all
     #      
     #      m = Member.create(:name => 'Lifetime')
     #      m.attendance.create(:raid_id => Raid.create(:date => 5.hours.ago).id, :attendance => 1.00)
     #      m.force_recache!
     #      m.attendance_lifetime.should == 1.00
     #      
     #      m.attendance.create(:raid_id => Raid.create(:date => 5.weeks.ago).id, :attendance => 1.00)
     #      m.force_recache!
     #      m.attendance_lifetime.should > 0.00
     #      m.attendance_lifetime.should_not > 1.00
     #    end

    it "should update the uncached_updates attribute" # do
     #      m = members(:tsigo)
     #      m.uncached_updates = 0
     # 
     #      1.upto(Member::CACHE_FLUSH - 1) do |x|
     #        m.attendance_30 = 1.00 * x.to_f
     #        m.save!
     #        m.uncached_updates.should == x
     #      end
     # 
     #      m.attendance_30 = 40.00
     #      m.save! # This save should trigger the update_cache method
     #      m.uncached_updates.should == 0
     #    end
  
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
  end
  
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
