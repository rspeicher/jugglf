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

  # TODO:
  # it "should call stop! on each associated Attendee" do
  #   live_raid = Factory(:live_raid_with_attendee, :started_at => Time.now)
  #   live_raid.attendees.each { |a| a.should_receive(:stop!) }
  #   live_raid.stop!
  # end
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