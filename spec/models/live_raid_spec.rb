# == Schema Information
#
# Table name: live_raids
#
#  id         :integer(4)      not null, primary key
#  started_at :datetime
#  stopped_at :datetime
#

require 'spec_helper'

describe LiveRaid do
  before(:each) do
    @live_raid = Factory(:live_raid)
  end
  
  it "should be valid" do
    @live_raid.should be_valid
  end
  
  it { should allow_mass_assignment_of(:attendees_string) }
  it { should_not allow_mass_assignment_of(:started_at) }
  it { should_not allow_mass_assignment_of(:stopped_at) }

  it { should have_many(:live_attendees).dependent(:destroy) }
  it { should have_many(:live_loots).dependent(:destroy) }

  it "should invalidate if stopped_at is set but not started_at" do
    lambda { @live_raid.stopped_at = Time.now }.should change(@live_raid, :valid?).to(false)
  end
end

describe LiveRaid, "#running_time_in_minutes" do
  it "should return 0 for an unstarted, unfinished raid" do
    Factory(:live_raid).running_time_in_minutes.should eql(0)
  end
  
  it "should return the running time in minutes for a finished raid" do
    live_raid = Factory(:live_raid, :started_at => Time.now, :stopped_at => 4.hours.since(Time.now))
    live_raid.running_time_in_minutes.should eql(240)
  end
  
  it "should return the running time in minutes for an unfinished raid" do
    live_raid = Factory(:live_raid, :started_at => 2.hours.until(Time.now), :stopped_at => nil)
    live_raid.running_time_in_minutes.should eql(120)
  end
end

describe LiveRaid, "#start" do
  before(:all) do
    Timecop.freeze(Time.now)
  end
  
  it "should set the value of started_at if the live raid has not yet started" do
    live_raid = Factory(:live_raid)
    lambda { live_raid.start! }.should change(live_raid, :started_at).to(Time.now)
  end
  
  it "should not change the value of started_at if the live raid has already started" do
    live_raid = Factory(:live_raid, :started_at => 1.minute.until(Time.now))
    lambda { live_raid.start! }.should_not change(live_raid, :started_at)
  end
  
  it "should call start! on each associated Attendee" do
    live_raid = Factory(:live_raid_with_attendees)
    live_raid.attendees.each { |a| a.should_receive(:start!) }
    live_raid.start!
  end
end

describe LiveRaid, "#stop" do
  before(:all) do
    Timecop.freeze(Time.now)
  end
  
  it "should set the value of stopped_at if the live raid has not yet been stopped" do
    live_raid = Factory(:live_raid, :started_at => 1.minute.until(Time.now))
    lambda { live_raid.stop! }.should change(live_raid, :stopped_at).to(Time.now)
  end
  
  it "should do nothing if the raid has not yet been started" do
    live_raid = Factory(:live_raid)
    lambda { live_raid.stop! }.should_not change(live_raid, :stopped_at)
  end
  
  it "should do nothing if the raid has already been stopped" do
    live_raid = Factory(:live_raid, :started_at => 1.minute.until(Time.now), :stopped_at => 1.minute.until(Time.now))
    lambda { live_raid.stop! }.should_not change(live_raid, :stopped_at)
  end

  it "should call stop! on each associated Attendee" do
    live_raid = Factory(:live_raid_with_attendees, :started_at => Time.now)
    live_raid.attendees.each { |a| a.should_receive(:stop!) }
    live_raid.stop!
  end
end

describe LiveRaid, "#status" do
  it "should return 'Pending' for an unstarted, unstopped raid" do
    live_raid = Factory(:live_raid)
    live_raid.status.should eql('Pending')
  end
  
  it "should return 'Active' for a started, unstopped raid" do
    live_raid = Factory(:live_raid, :started_at => Time.now)
    live_raid.status.should eql('Active')
  end
  
  it "should return 'Completed' for a stopped raid" do
    live_raid = Factory(:live_raid, :started_at => Time.now, :stopped_at => Time.now)
    live_raid.status.should eql('Completed')
  end
end

describe LiveRaid, "#active?" do
  it "should be true if active" do
    Factory(:live_raid, :started_at => Time.now).active?.should be_true
  end
  
  it "should otherwise be false" do
    Factory(:live_raid).active?.should be_false
  end
end

describe LiveRaid, "#attendees_string" do
  it "should assign to attendees collection" do
    live_raid = Factory(:live_raid)
    live_raid.attendees_string = 'Tsigo,Sebudai'
    live_raid.attendees.length.should eql(2)
    live_raid.attendees[0].live_raid_id.should eql(live_raid.id)
  end
  
  it "should work on an unsaved LiveRaid" do
    live_raid = Factory.build(:live_raid)
    live_raid.attendees_string = 'Tsigo,Sebudai'
    live_raid.attendees.length.should eql(2)
    lambda { live_raid.save }.should change(live_raid.attendees[0], :live_raid_id)
  end
  
  it "should start a new attendee if the current raid is active" do
    live_raid = Factory(:live_raid)
    live_raid.start!
    live_raid.attendees_string = 'Tsigo'
    live_raid.attendees[0].active?.should be_true
    live_raid.attendees[0].started_at.should_not be_nil
  end
  
  it "should add a new attendee to an already existing collection" do
    live_raid = Factory(:live_raid_with_attendees)
    live_raid.start!
    lambda { live_raid.attendees_string = 'Tsigo,Sebudai' }.should change(live_raid.attendees, :length).from(2).to(4)
  end
  
  describe "when given an existing attendee" do
    before(:each) do
      @live_raid = Factory(:live_raid_with_attendees)
      @existing = @live_raid.attendees[0]
    end
    
    after(:each) do
      @live_raid.attendees_string = @existing.member_name
    end
    
    it "should do nothing if raid is not active" do
      @live_raid.stop!
      @existing.should_not_receive(:toggle!)
    end
    
    it "should call toggle! if raid is active" do
      @live_raid.start!
      @existing.should_receive(:toggle!)
    end
  end
end