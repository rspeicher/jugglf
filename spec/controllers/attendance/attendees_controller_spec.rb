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
  
  def params(extras = {})
    {:live_raid_id => @parent.id, :id => @live_attendee.id}.merge!(extras)
  end
end

describe Attendance::AttendeesController, "routing" do
  it { should route(:put,    '/attendance/1/attendees/2').to(:controller => 'attendance/attendees', :action => :update,  :live_raid_id => '1', :id => '2') }
  it { should route(:delete, '/attendance/1/attendees/2').to(:controller => 'attendance/attendees', :action => :destroy, :live_raid_id => '1', :id => '2') }
end

describe Attendance::AttendeesController, "#update" do
  include AttendanceAttendeesHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @live_attendee.should_receive(:toggle!)    
    put :update, params
  end
  
  it { should respond_with(:success) }
end

describe Attendance::AttendeesController, "#destroy" do
  include AttendanceAttendeesHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @live_attendee.should_receive(:destroy)
    delete :destroy, params
  end
  
  it { should respond_with(:success) }
end