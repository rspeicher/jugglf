require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Raid do
  fixtures :raids
  
  before(:each) do
    @valid_attributes = {
      :date => Time.now.to_s(:db)
    }
  end

  it "should create a new instance given valid attributes" do
    Raid.create!(@valid_attributes)
  end
  
  it "should count the number of raids in the last thirty days" do
    Raid.destroy_all
    Raid.count_last_thirty_days.should == 0
    
    Raid.create(:date => 60.days.ago)
    Raid.create(:date => 25.days.ago)
    Raid.create(:date => 20.days.ago)
    
    Raid.count_last_thirty_days.should == 2
  end
  
  it "should count the number of raids in the last ninety days" do
    Raid.destroy_all
    Raid.count_last_ninety_days.should == 0
    
    Raid.create(:date => 60.days.ago)
    Raid.create(:date => 25.days.ago)
    Raid.create(:date => 20.days.ago)
    
    Raid.count_last_ninety_days.should == 3
  end
  
  # ---------------------------------------------------------------------------
  
  describe "with attendees" do
    fixtures :members
    
    it "can postpone attendee cache updates" do
      r = raids(:today)

      r.attendees.create(:member_id => members(:tsigo).id, :attendance => 0.50)

      r.update_attendee_cache = false
      r.save
      r.reload

      # Cache hasn't been updated yet, members' attendance should still be 100%
      Member.find_by_name('Tsigo').attendance_30.should == 1.00

      # Create a new object so the update_attendee_cache value doesn't linger around
      r1 = Raid.find(r.id)
      r1.save

      Member.find_by_name('Tsigo').attendance_30.should_not == 1.00
    end
  end
  
  # ---------------------------------------------------------------------------
  
  describe "from yesterday" do
    it "should be in the last thirty days" do
      raids(:yesterday).is_in_last_thirty_days?.should be_true
    end
    
    it "should be in the last ninety days" do
      raids(:yesterday).is_in_last_ninety_days?.should be_true
    end
  end
  
  # ---------------------------------------------------------------------------
  
  describe "from two months ago" do
    it "should not be in the last thirty days" do
      raids(:two_months_ago).is_in_last_thirty_days?.should_not be_true
    end
    
    it "should be in the last ninety days" do
      raids(:two_months_ago).is_in_last_ninety_days?.should be_true
    end
  end
  
  # ---------------------------------------------------------------------------
  
  describe "from JuggyAttendance output" do
    before(:all) do
      @attendees = %Q{Sebudai,1.00,233
      Squallalaha,1.00,233
      Darkkfall,1.00,233
      Bemoan,1.00,233
      Kurgle,1.00,233
      Scipion,1.00,233
      Zelus,1.00,233
      Thorona,1.00,233
      Duskshadow,1.00,233
      Inaya,1.00,233
      Trithion,1.00,233
      Alephone,1.00,233
      Sadris,1.00,233
      Ruhntar,1.00,233
      Garudon,1.00,233
      Faires,1.00,233
      Rosoo,1.00,233
      Sweetmeat,1.00,233
      Zyxn,1.00,233
      Szer,1.00,233
      Modrack,1.00,233
      Baud,1.00,233
      Leowon,1.00,233
      Quinta,1.00,233
      Parawon,1.00,233
      Souai,1.00,233
      Dalvian,1.00,233
      Horky,1.00,233
      Fearsom,1.00,233
      Tsigo,1.00,233
      Katarzyna,0.83,194
      Kapetal,0.83,194
      }
      
      @attendees_with_duplicates = %Q{Sebudai,1.00,233
      Sebudai,1.00,
      Tsigo,1.00,233,
      Tsigo,0.83,233
      }
      
      @loot = %Q{Sebudai - [Arachnoid Gold Band]
      Scipion - [Chains of Adoration]
      Elanar (rot), Alephone (sit) - [Shadow of the Ghoul]
      Scipion (bis) - [Totem of Misery]
      Scipion - [Wraith Strike]
      Horky (bis) - [Dying Curse]
      Parawon (sit) - [Thrusting Bands]
      Scipion (sit) - [Angry Dread]
      Parawon - [Belt of Potent Chanting]
      Scipion (sit) - [Fool's Trial]
      Tsigo (sit) - [Haunting Call]
      Sebudai (sit) - [Leggings of Colossal Strides]
      Parawon (sit) - [Cloak of the Shadowed Sun]
      Sebudai (rot) - [The Hand of Nerub]
      Elanar (bis) - [Mantle of the Lost Protector]
      Tsigo (rot) - [Mantle of the Lost Conqueror]
      Darkkfall - [Shoulderguards of the Undaunted]
      Darkkfall (bis) - [Split Greathammer]
      Zelus (bis) - [Gemmed Wand of the Nerubians]
      Mithal (bis) - [Breastplate of the Lost Conqueror]
      Tsigo (sit) - [Spire of Sunset]
      Alephone (bis) - [Legplates of the Lost Conqueror]
      Sweetmeat (bis) - [Strong-Handed Ring]
      Darkkfall (bis) - [Bracers of Unrelenting Attack]
      Thorona (bis) - [Gothik's Cowl]
      Sebudai - [Aged Winter Cloak]
      Elanar (sit) - [Armageddon]
      Alephone (sit) - [Breastplate of the Lost Conqueror]
      Bemoan (bis) - [Heroic Key to the Focusing Iris]
      Alephone (bis) - [Soul of the Dead]
      Katarzyna (bis) - [Betrayer of Humanity]
      Sebudai (rot) - [Journey's End]
      Scipion (sit) - [Voice of Reason]
      Modrack (bis), Rosoo (bis) - [Crown of the Lost Vanquisher]
      }
    end
    
    before(:each) do
      Raid.delete_all
      
      @r = Raid.new(:date => Time.now, :note => "JuggyAttendance Output")
    end
    
    it "should populate attendees" do
      Member.delete_all
      
      @r.members.count.should == 0
      
      @r.attendance_output = @attendees
      @r.update_attendee_cache = false
      @r.save
      @r.reload
      
      Member.all.count.should == 32
      
      # TODO: Which of these is correct? No idea, let's check 'em all!
      @r.attendees.size.should   == 32
      @r.attendees.length.should == 32
      @r.members.count.should    == 32
      @r.attendees_count.should  == 32
      
      m = Member.find_by_name('Kapetal')
      m.attendance[0].attendance.should == 0.83
    end
    
    it "should disregard duplicate attendee rows" do
      @r.attendance_output = @attendees_with_duplicates
      @r.update_attendee_cache = false
      
      lambda { @r.save }.should_not raise_error
    end
    
    it "should use lower attendance value for duplicate attendee rows" do
      @r.attendance_output = @attendees_with_duplicates
      @r.update_attendee_cache = false
      @r.save
      
      Member.find_by_name('Tsigo').attendance[0].attendance.should == 0.83
    end
    
    # OPTIMIZE: This might be slow because of item.determine_item_price() being called for each item
    it "should populate drops" do
      @r.items.size.should == 0
      
      @r.loot_output = @loot
      @r.save
      @r.reload
      
      @r.items.size.should   == 36
      @r.items.length.should == 36
      @r.items.count.should  == 36
    end
  end
end
