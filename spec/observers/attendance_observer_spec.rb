require 'spec_helper'

describe AttendanceObserver do
  it "should delete a corresponding LiveRaid when a Raid is added" do
    start = Time.mktime(2011, 07, 02, 20, 30)
    stop  = Time.mktime(2011, 07, 03, 00, 30)

    to_delete = Factory(:live_raid, :started_at => start, :stopped_at => stop)
    to_keep   = Factory(:live_raid, :started_at => start + 1.day, :stopped_at => stop + 1.day)

    Factory(:raid, :date => '2011-07-02')

    LiveRaid.all.should eql([to_keep])
  end
end
