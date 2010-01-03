# == Schema Information
#
# Table name: live_attendees
#
#  id               :integer(4)      not null, primary key
#  member_name      :string(255)     not null
#  live_raid_id     :integer(4)
#  started_at       :datetime
#  stopped_at       :datetime
#  active           :boolean(1)
#  minutes_attended :integer(4)      default(0)
#

require 'spec_helper'

describe LiveAttendee do
  before(:each) do
    @live_att = Factory(:live_attendee)
  end
  
  it "should be valid" do
    @live_att.should be_valid
  end

  it { should allow_mass_assignment_of(:member_name) }
  it { should allow_mass_assignment_of(:live_raid_id) }
  it { should_not allow_mass_assignment_of(:started_at) }
  it { should_not allow_mass_assignment_of(:stopped_at) }
  it { should_not allow_mass_assignment_of(:active) }
  it { should_not allow_mass_assignment_of(:minutes_attended) }  

  it { should belong_to(:live_raid) }
  
  it { should validate_presence_of(:member_name) }
  it { should validate_uniqueness_of(:member_name).scoped_to(:live_raid_id) }
end

describe LiveAttendee, "#toggle!" do
  it "should call start if the user is not active" do
    att = Factory(:live_attendee, :active => false)
    att.should_receive(:start!)
    att.toggle!
  end
  
  it "should call stop if the user is active" do
    att = Factory(:live_attendee, :active => true)
    att.should_receive(:stop!)
    att.toggle!
  end
end

describe LiveAttendee, "#start!" do
  before(:all) do
    Timecop.freeze(Time.now)
  end
  
  before(:each) do
    @live_att = Factory(:live_attendee, :started_at => nil, :stopped_at => nil, :active => false)
  end
  
  it "should do nothing if active and running" do
    @live_att.active = true
    @live_att.started_at = Time.now
    @live_att.start!.should eql(nil)
  end
  
  it "should change active? to true" do
    lambda { @live_att.start! }.should change(@live_att, :active?).from(false).to(true)
  end
  
  it "should change started_at to the current time" do
    lambda { @live_att.start! }.should change(@live_att, :started_at).from(nil).to(Time.now)
  end
end

describe LiveAttendee, "#stop!" do
  before(:all) do
    Timecop.freeze(Time.now)
  end
  
  before(:each) do
    @live_att = Factory(:live_attendee, :started_at => 1.minute.until(Time.now), :stopped_at => nil, :active => true)
  end
  
  it "should do nothing if not active" do
    @live_att.active = false
    @live_att.stop!.should eql(nil)
  end
  
  it "should change active? to false" do
    lambda { @live_att.stop! }.should change(@live_att, :active?).from(true).to(false)
  end
  
  it "should set started_at to nil" do
    lambda { @live_att.stop! }.should change(@live_att, :started_at).to(nil)
  end
  
  it "should set stopped_at to the current time" do
    lambda { @live_att.stop! }.should change(@live_att, :stopped_at).from(nil).to(Time.now)
  end
  
  it "should set the minutes_attended attribute" do
    lambda { @live_att.stop! }.should change(@live_att, :minutes_attended).from(0).to(1)
  end
  
  it "should increase existing minutes_attended" do
    # Set the baseline minutes_attended to 60
    @live_att.started_at = 1.hour.until(Time.now)
    @live_att.stop!
    
    # Now add 3 more hours
    lambda {
      @live_att.active = true
      @live_att.started_at = 3.hours.until(Time.now)
      @live_att.stop!
    }.should change(@live_att, :minutes_attended).from(60).to(240)
  end
end

describe LiveAttendee, "#active_minutes" do
  before(:all) do
    Timecop.freeze(Time.now)
  end
  
  before(:each) do
    @live_att = Factory(:live_attendee_with_raid, :started_at => 20.minutes.until(Time.now))
  end
  
  it "should return 0 for an unstarted record" do
    Factory(:live_attendee).active_minutes.should eql(0)
  end
  
  it "should calculate the active minutes if the current value is 0" do
    @live_att.minutes_attended.should eql(0)
    @live_att.active_minutes.should eql(20)
  end
  
  it "should return already-calculated active minutes if current value is not 0" do
    @live_att.stop!
    @live_att.minutes_attended.should eql(20)
    @live_att.active_minutes.should eql(20)
  end
  
  # An attendee was active in the same raid for 10 minutes, left for 20 minutes, and then came back.
  # Their +minutes_attended+ would be 10, but +active_minutes+ would be 50.
  describe "after multiple toggles" do
    it "should be correct" do
      @live_att = Factory(:live_attendee_with_raid, :started_at => Time.now)

      # Leave after 10 minutes attended
      Timecop.freeze(10.minutes.since(Time.now)) do
        @live_att.toggle!
        @live_att.active?.should be_false
        @live_att.minutes_attended.should eql(10)
        @live_att.active_minutes.should eql(10)
      end
      
      # Rejoin after being gone for 20 minutes; they've still been active for 10 minutes
      Timecop.freeze(20.minutes.since(Time.now)) do
        @live_att.toggle!
        @live_att.active?.should be_true
        @live_att.minutes_attended.should eql(10)
        @live_att.active_minutes.should eql(10)
      end

      # At the end of a 60 minute raid, their total should be 50
      Timecop.freeze(60.minutes.since(Time.now)) do
        @live_att.active?.should be_true
        @live_att.minutes_attended.should eql(10)
        @live_att.active_minutes.should eql(50)
      end
    end
  end
end

describe LiveAttendee, ".from_text" do
  before(:each) do
    @text = "Tsigo,Duskshadow, Sebudai, Baud,Souai,Tsigo,Tsigo"
    @attendees = LiveAttendee.from_text(@text)
  end
  
  it "should return an empty array if no text is given" do
    LiveAttendee.from_text(nil).should eql([])
  end
  
  it "should ignore duplicates" do
    @attendees.length.should eql(5)
  end

  it "should return an array of LiveAttendee objects" do
    @attendees[0].should be_a(LiveAttendee)
  end
  
  it "should not save the LiveAttendee records" do
    @attendees[0].new_record?.should be_true
  end
  
  it "should correctly set the member_name attribute" do
    @attendees[0].member_name.should eql('Tsigo')
  end
end
