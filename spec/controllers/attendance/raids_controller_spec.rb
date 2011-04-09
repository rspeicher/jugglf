require 'spec_helper'

describe Attendance::RaidsController, "routing" do
  it { should route(:get,    '/attendance'        ).to(:controller => 'attendance/raids', :action => :index) }
  it { should route(:post,   '/attendance'        ).to(:controller => 'attendance/raids', :action => :create) }
  it { should route(:get,    '/attendance/new'    ).to(:controller => 'attendance/raids', :action => :new) }
  it { should route(:get,    '/attendance/1/start').to(:controller => 'attendance/raids', :action => :start,   :id => '1') }
  it { should route(:get,    '/attendance/1/stop' ).to(:controller => 'attendance/raids', :action => :stop,    :id => '1') }
  it { should route(:get,    '/attendance/1/post' ).to(:controller => 'attendance/raids', :action => :post,    :id => '1') }
  it { should route(:get,    '/attendance/1'      ).to(:controller => 'attendance/raids', :action => :show,    :id => '1') }
  it { should route(:put,    '/attendance/1'      ).to(:controller => 'attendance/raids', :action => :update,  :id => '1') }
  it { should route(:delete, '/attendance/1'      ).to(:controller => 'attendance/raids', :action => :destroy, :id => '1') }
end

describe Attendance::RaidsController, "GET index" do
  before do
    get :index
  end

  it { should respond_with(:success) }
  it { should assign_to(:raids) }
  it { should render_template(:index) }
end

describe Attendance::RaidsController, "GET show" do
  before do
    @resource = Factory(:live_raid)
    get :show, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:live_raid).with(@resource) }
  it { should render_template(:show) }
end

describe Attendance::RaidsController, "GET new" do
  before do
    get :new
  end

  it { should respond_with(:success) }
  it { should assign_to(:live_raid).with_kind_of(LiveRaid) }
  it { should render_template(:new) }
end

describe Attendance::RaidsController, "POST create" do
  before do
    @resource = Factory.build(:live_raid)
    LiveRaid.expects(:new).with({}).returns(@resource)
  end

  context "success" do
    before do
      post :create, :live_raid => {}
    end

    it { should respond_with(:redirect) }
    it { should redirect_to(live_raid_path(@resource)) }
  end

  context "failure" do
    before do
      @resource.expects(:save).returns(false)
      post :create, :live_raid => {}
    end

    it { should respond_with(:success) }
    it { should render_template(:new) }
  end
end

describe Attendance::RaidsController, "PUT update" do
  context "success" do
    before do
      LiveRaid.any_instance.expects(:update_attributes).with({}).returns(true)
      put :update, :id => Factory(:live_raid), :live_raid => {}
    end

    it { should_not set_the_flash }
    it { should redirect_to(live_raid_path(@resource)) }
  end

  context "failure" do
    before do
      LiveRaid.any_instance.expects(:update_attributes).with({}).returns(false)
      put :update, :id => Factory(:live_raid), :live_raid => {}
    end

    it { should set_the_flash.to(/failed to update/i) }
    it { should redirect_to(live_raid_path(@resource)) }
  end
end

describe Attendance::RaidsController, "DELETE destroy" do
  before do
    @resource = Factory(:live_raid)
    delete :destroy, :id => @resource
  end

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(live_raids_path) }
end

describe Attendance::RaidsController, "GET start" do
  before do
    @resource = Factory(:live_raid)
    LiveRaid.any_instance.expects(:start!)

    get :start, :id => @resource
  end

  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@resource)) }
end

describe Attendance::RaidsController, "GET stop" do
  before do
    @resource = Factory(:live_raid)
    LiveRaid.any_instance.expects(:stop!)

    get :stop, :id => @resource.id
  end

  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@resource)) }
end

describe Attendance::RaidsController, "GET post" do
  context "completed raid" do
    before do
      @resource = Factory(:live_raid, :started_at => Time.now, :stopped_at => Time.now)
      @resource.expects(:post).with(anything())
      LiveRaid.expects(:find).returns(@resource)
      get :post, :id => @resource
    end

    it { should set_the_flash.to(/created attendance thread/) }
    it { should redirect_to(live_raids_path) }
  end

  context "active raid" do
    before do
      @resource = Factory(:live_raid, :started_at => Time.now)
      @resource.expects(:post).never
      LiveRaid.expects(:find).returns(@resource)
      get :post, :id => @resource
    end

    it { should_not set_the_flash }
    it { should redirect_to(live_raid_path(@resource)) }
  end
end
