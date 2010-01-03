require 'spec_helper'

module AttendanceAttendeesHelperMethods
  def mock_find
    # This is a namespaced controller, so it always has a parent
    # We stub :attendees to LiveAttendee so that @parent.attendees.find works as expected
    @parent ||= @live_raid ||= mock_model(LiveRaid, :attendees => LiveAttendee)
    LiveRaid.should_receive(:find).with(anything()).and_return(@live_raid)
  
    @live_attendee ||= mock_model(LiveAttendee)
    LiveAttendee.should_receive(:find).with(anything()).and_return(@live_attendee)
  end
end

describe Attendance::AttendeesController, "#update" do
  include AttendanceAttendeesHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @live_attendee.should_receive(:toggle!)    
    put :update, :live_raid_id => @parent.id, :id => @live_attendee.id
  end
  
  it { should respond_with(:success) }
end

describe Attendance::AttendeesController, "#destroy" do
  include AttendanceAttendeesHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @live_attendee.should_receive(:destroy)
    delete :destroy, :live_raid_id => @parent.id, :id => @live_attendee.id
  end
  
  it { should respond_with(:success) }
end