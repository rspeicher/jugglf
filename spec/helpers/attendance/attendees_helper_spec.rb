require 'spec_helper'

include Attendance::AttendeesHelper

describe "link_to_toggle_attendee" do
  before(:each) do
    @raid = Factory(:live_raid_with_attendee)
    @attendee = @raid.attendees[0]
    
    @raid.start!
  end
  
  it "should return only an image if the raid is not active" do
    @raid.stop!
    link_to_toggle_attendee(@attendee).should_not match(/href/)
  end
  
  it "should return a link if the raid is active" do
    link_to_toggle_attendee(@attendee).should match(/href/)
  end
  
  it "should contain tick.png if attendee is active" do
    @raid.start!
    link_to_toggle_attendee(@attendee).should match(/tick\.png/)
  end
  
  it "should contain cancel.png if attendee is not active" do
    @attendee.stop!
    link_to_toggle_attendee(@attendee).should match(/cancel\.png/)
  end
end
