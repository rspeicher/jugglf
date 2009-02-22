require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Automator do
  before(:each) do
    @raid = Raid.make
    @raid.attendance_output = "Sebudai,1.00,233"
    @raid.loot_output = "Sebudai - [Arachnoid Gold Band]"
  end
  
  describe "output from JuggyAttendance" do
    it "should return an array of items"
  
    it "should return an array of attendees"
  end
end
