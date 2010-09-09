require 'spec_helper'

describe Attendance::AttendeesController, "routing" do
  it { should route(:put,    '/attendance/1/attendees/2').to(:controller => 'attendance/attendees', :action => :update,  :live_raid_id => '1', :id => '2') }
  it { should route(:delete, '/attendance/1/attendees/2').to(:controller => 'attendance/attendees', :action => :destroy, :live_raid_id => '1', :id => '2') }
end

describe Attendance::AttendeesController, "#update" do
  before do
    @parent   = Factory(:live_raid_with_attendee)
    @resource = @parent.attendees.first
    @resource.expects(:toggle!)

    # Make sure @parent.attendees.find(params[:id]) in the controller returns our specific resource
    # so that expectations work... as expected
    LiveRaid.any_instance.stubs(:attendees).returns(stub(:find => @resource))

    xhr :put, :update, :live_raid_id => @parent, :id => @resource
  end

  it { should respond_with(:success) }
end

describe Attendance::AttendeesController, "#destroy" do
  before do
    @parent   = Factory(:live_raid_with_attendee)
    @resource = @parent.attendees.first
    @resource.expects(:destroy)

    LiveRaid.any_instance.stubs(:attendees).returns(stub(:find => @resource))
  end

  context ".html" do
    before { delete :destroy, :live_raid_id => @parent, :id => @resource }
    it { should redirect_to(live_raid_path(@parent)) }
  end

  context ".js" do
    before { xhr :delete, :destroy, :live_raid_id => @parent, :id => @resource }
    it { should respond_with(:success) }
  end
end
