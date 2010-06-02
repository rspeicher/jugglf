require 'spec_helper'

describe Raid do
  before(:each) do
    @raid = Factory(:raid)
  end

  it "should be valid" do
    @raid.should be_valid
  end

  context "mass assignment" do
    it { should allow_mass_assignment_of(:date) }
    it { should allow_mass_assignment_of(:note) }
    it { should_not allow_mass_assignment_of(:attendees_count) }
    it { should_not allow_mass_assignment_of(:loots_count) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  context "associations" do
    it { should have_many(:attendees).dependent(:destroy) }
    it { should have_many(:loots).dependent(:destroy) }
    it { should have_many(:members).through(:attendees) }
  end

  context "validations" do
    it { should validate_presence_of(:date) }
  end

  it "should have a custom to_s" do
    @raid.to_s.should eql("#{@raid.date}")
  end
end

describe Raid, "#date_string" do
  before(:each) do
    Timecop.freeze(Date.today)
    @raid = Factory(:raid)
  end

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

describe Raid, "#update_cache" do
  before(:each) do
    @raid = Factory(:raid)
    @member = Factory(:member, :attendance_30 => 1.00)
    Factory(:attendee, :member => @member, :raid => @raid, :attendance => 0.50)
  end

  it "should update attendee cache unless disabled" do
    @raid.update_cache = true

    lambda {
      @raid.save
      @member.reload
    }.should change(@member, :attendance_30).to(0.50)
  end

  it "should allow disabling of attendee cache updates" do
    @raid.update_cache = false

    lambda {
      @raid.save
      @member.reload
    }.should_not change(@member, :attendance_30)
  end

  it "should update purchased_on attribute for child loots" do
    @raid.loots << Factory.build(:loot)
    @raid.update_cache = false
    @raid.save

    @raid.loots[0].purchased_on.should eql(@raid.date)
  end
end

describe Raid, "date ranges" do
  before(:each) do
    @raids = {
      :today       => Factory(:raid),
      :two_months  => Factory(:raid, :date => 2.months.until(Date.today)),
      :four_months => Factory(:raid, :date => 4.months.until(Date.today))
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
    @raid = Factory(:raid)
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
    member = Factory(:member, :name => 'Kapetal')
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
    AttendanceParser.should_receive(:parse_loots).and_return([{:item => Factory(:item), :price => 1.00}])

    @raid = Factory(:raid)
    @raid.loot_output = "Sebudai - [Torch of Holy Fire]"
  end

  it "should populate #loots from output" do
    lambda { @raid.save }.should change(@raid.loots, :size)
  end
end
