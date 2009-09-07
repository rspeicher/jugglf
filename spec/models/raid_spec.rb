# == Schema Information
#
# Table name: raids
#
#  id              :integer(4)      not null, primary key
#  date            :date
#  note            :string(255)
#  attendees_count :integer(4)      default(0)
#  loots_count     :integer(4)      default(0)
#  created_at      :datetime
#  updated_at      :datetime
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
  
  it "should have attendees" do
    2.times { @raid.attendees.make }
    
    @raid.reload
    @raid.attendees_count.should eql(2)
    @raid.attendees.size.should eql(2)
  end
  
  it "should have loots" do
    @raid.loots.make
    
    @raid.reload
    @raid.loots_count.should eql(1)
    @raid.loots.size.should eql(1)
  end
  
  describe "#date_string" do
    it "should return today's date as a string if no date is given" do
      @raid.date = nil
      @raid.date_string.should eql(Date.today.to_s(:db))
    end

    it "should return a string of its date value" do
      @raid.date = 3.days.until(Date.today)
      @raid.date_string.should eql(3.days.until(Date.today).to_s(:db))
    end

    it "should modify the date attribute" do
      @raid.date_string = '2003-01-01'
      @raid.date.to_s(:db).should match(/^2003-01-01.+/)
    end
  end
  
  describe "#update_cache" do
    before(:each) do
      @member = Member.make(:attendance_30 => 1.00)
      @raid.attendees.make(:member => @member, :attendance => 0.50)
    end
    
    it "should update attendee cache unless disabled" do
      @raid.update_cache = true
      
      lambda do
        @raid.save
        @member.reload
      end.should change(@member, :attendance_30)
    end
    
    it "should allow disabling of attendee cache updates" do
      @raid.update_cache = false
      
      lambda do
        @raid.save
        @member.reload
      end.should_not change(@member, :attendance_30)
    end
    
    it "should update purchased_on attribute for child loots" do
      Item.destroy_all
      
      @raid.loots.make(:purchased_on => 15.days.ago)
      @raid.update_cache = false
      @raid.save
      
      @raid.loots.find(:first).purchased_on.should eql(@raid.date)
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
    Raid.count_last_thirty_days.should eql(1)
  end
  
  it "should count the total number of raids in the last ninety days" do
    Raid.count_last_ninety_days.should eql(2)
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
    [Attendee, Loot].each(&:destroy_all)
    @raid = Raid.make

    2.times { Attendee.make(:member => Member.make, :raid => @raid) }
    1.times { @raid.loots.make }
  end

  it "should destroy associated attendees when destroyed" do
    @raid.destroy
    Attendee.count.should eql(0)
  end
  
  it "should destroy associated loots when destroyed" do
    @raid.destroy
    Loot.count.should eql(0)
  end
end

describe Raid, "#parse_attendees" do
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
    @raid.update_cache = false
  end
  
  it "should not raise an exception for duplicates" do
    lambda { @raid.save }.should_not raise_error
  end
  
  it "should create non-existant members" do
    lambda { @raid.save }.should change(Member, :count).by(3)
  end
  
  it "should update existing members" do
    member = Member.make(:name => 'Kapetal', :raids_count => 50)
    @raid.save
    
    lambda { member.reload }.should change(member, :raids_count).by(1)
  end
  
  it "should use the lower attendance percentage when a duplicate is present" do
    @raid.save
    
    kapetal = Member.find_by_name('Kapetal')
    kapetal.raids.size.should eql(1)
    kapetal.attendance[0].attendance.should eql(0.83)
  end
  
  it "should return a string-based representation of attendees" do
    @raid.save
    @raid.reload
    
    @raid.attendance_output.should eql("Sebudai,1.0\nKatarzyna,0.5\nKapetal,0.83")
  end
  
  it "should handle removed attendees on update" do
    @raid.save
    
    # Remove the Kapetals from the output
    @output = @output.split("\n").slice(0,2).join("\n")
    
    # Though we removed 2 lines, 1 of them was a duplicate, so this will only change by -1
    lambda { @raid.update_attributes(:attendance_output => @output) }.should change(Attendee, :count).by(-1)
  end
end

describe Raid, "#parse_drops" do
  before(:each) do
    [Loot, Raid].each(&:destroy_all)
    @raid = Raid.make
    @raid.loot_output = "Sebudai - [Arachnoid Gold Band]"
    
    Item.stub!(:open).
      and_return(File.read(RAILS_ROOT + '/spec/fixtures/wowhead/item_40395.xml'))
  end
  
  it "should populate #loots from output" do
    lambda { @raid.save }.should change(@raid.loots, :size)
  end
end
