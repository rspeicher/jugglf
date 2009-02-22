# == Schema Information
# Schema version: 20090213233547
#
# Table name: raids
#
#  id              :integer(4)      not null, primary key
#  date            :date
#  note            :string(255)
#  thread          :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  attendees_count :integer(4)      default(0)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Raid do
  before(:each) do
    @raid = Raid.make
    
    Raid.make(:date => 60.days.ago)
  end
  
  it "should be valid" do
    @raid.should be_valid
  end
  
  describe "#date_string" do
    it "should return today's date as a string if no date is given" do
      @raid.date = nil
      @raid.date_string.should == Date.today.to_s(:db)
    end

    it "should return a string of its date value" do
      @raid.date = 3.days.until(Date.today)
      @raid.date_string.should == 3.days.until(Date.today).to_s(:db)
    end

    it "should modify the date attribute" do
      @raid.date_string = '2003-01-01'
      @raid.date.to_s(:db).should match(/^2003-01-01.+/)
    end
  end
  
  describe "#update_attendee_cache" do
    it "should allow disabling of attendee cache updates" do
      member = Member.make(:attendance_30 => 1.00)
      
      @raid.update_attendee_cache = false
      @raid.attendees.make(:member => member, :attendance => 0.50)
      
      lambda do
        @raid.save
        member.reload
      end.should_not change(member, :attendance_30)
    end
  end
end

# -----------------------------------------------------------------------------

describe Raid do
  before(:each) do
    Raid.destroy_all
    
    @raids = {
      :today       => Raid.make,
      :two_months  => Raid.make(:date => 2.months.ago),
      :four_months => Raid.make(:date => 4.months.ago)
    }
  end
  
  it "should count the total number of raids in the last thirty days" do
    Raid.count_last_thirty_days.should == 1
  end
  
  it "should count the total number of raids in the last ninety days" do
    Raid.count_last_ninety_days.should == 2
  end
  
  it "should know if it was in the last thirty days" do
    @raids[:today].is_in_last_thirty_days?.should be_true
    @raids[:four_months].is_in_last_thirty_days?.should be_false
  end
  
  it "should know if it was in the last ninety days" do
    @raids[:today].is_in_last_ninety_days?.should be_true
    @raids[:four_months].is_in_last_ninety_days?.should be_false
  end
end

# -----------------------------------------------------------------------------

describe Raid, "dependencies" do
  before(:each) do
    [Attendee, Item].each(&:destroy_all)
    @raid = Raid.make

    3.times { Attendee.make(:member => Member.make, :raid => @raid) }
    2.times { @raid.items.make }
  end

  it "should destroy associated attendees when destroyed" do
    Attendee.count.should == 3
    @raid.destroy
    Attendee.count.should == 0
  end
  
  it "should destroy associated items when destroyed" do
    Item.count.should == 2
    @raid.destroy
    Item.count.should == 0
  end
end

describe Raid, "#attendance_output" do
  before(:all) do
    @output = <<-END
    Sebudai,1.00,233
    Katarzyna,0.50
    Kapetal,1.00
    Kapetal,0.83,194
    END
  end
  
  before(:each) do
    [Attendee, Member, Raid].each(&:destroy_all)
    @raid = Raid.make
    @raid.attendance_output = @output
    @raid.update_attendee_cache = false
  end
  
  it "should create non-existant members" do
    lambda { @raid.save }.should change(Member, :count).by(3)
  end
  
  it "should update existing members" do
    member = Member.make(:name => 'Kapetal', :raids_count => 50)
    @raid.save
    
    lambda { member.reload }.should change(member, :raids_count).by(1)
  end
  
  it "should not raise an exception for duplicates" do
    lambda { @raid.save }.should_not raise_error
  end
  
  it "should use the lower attendance percentage when a duplicate is present" do
    @raid.save
    
    kapetal = Member.find_by_name('Kapetal')
    kapetal.raids.size.should == 1
    kapetal.attendance[0].attendance.should == 0.83
  end
end

describe Raid, "#loot_output" do
  before(:each) do
    [Item, Raid].each(&:destroy_all)
    @raid = Raid.make
    @raid.loot_output = "Sebudai - [Arachnoid Gold Band]"
  end
  
  it "should populate #items from output" do
    lambda { @raid.save }.should change(@raid.items, :size)
  end
end
