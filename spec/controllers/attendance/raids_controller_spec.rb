require 'spec_helper'

module AttendanceRaidsHelperMethods
  def mock_find
    @live_raid ||= Factory(:live_raid)
    LiveRaid.should_receive(:find).with(anything()).exactly(:once).and_return(@live_raid)
  end

  def mock_new
    @live_raid ||= Factory(:live_raid)
    LiveRaid.should_receive(:new).and_return(@live_raid)
  end
  
  def mock_xmlrpc
    require 'xmlrpc/client'
    server = mock('Server')
    XMLRPC::Client.stub!(:new2).and_return(server)
    server.stub!(:call).and_return({})
  end
end

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
  describe "basics" do
    before(:each) do
      login(:admin)
      get :index
    end
  
    it { should assign_to(:raids).with_kind_of(Array) }
    it { should render_template(:index) }
    it { should respond_with(:success) }
  end
end

describe Attendance::RaidsController, "GET show" do
  include AttendanceRaidsHelperMethods
  
  describe "basics" do
    before(:each) do
      login(:admin)
      mock_find
      get :show, :id => @live_raid.id
    end
    
    it { should assign_to(:live_raid).with_kind_of(LiveRaid) }
    it { should render_template(:show) }
    it { should respond_with(:success) }
  end
end

describe Attendance::RaidsController, "GET new" do
  describe "basics" do
    before(:each) do
      login(:admin)
      get :new
    end
  
    it { should assign_to(:live_raid).with_kind_of(LiveRaid) }
    it { should render_template(:new) }
    it { should respond_with(:success) }
  end
end

describe Attendance::RaidsController, "POST create" do
  include AttendanceRaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_new
    @params = {:live_raid => {:attendees_string => ''}}
  end
  
  describe "success" do
    before(:each) do
      @live_raid.should_receive(:save).and_return(true)
      post :create, @params
    end
    
    it { should respond_with(:redirect) }
    it { should redirect_to(live_raid_path(@live_raid)) }
  end
  
  describe "failure" do
    before(:each) do
      @live_raid.should_receive(:save).and_return(false)
      post :create, @params
    end
    
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end
end

describe Attendance::RaidsController, "PUT update" do
  include AttendanceRaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @params = {:id => @live_raid.id, :live_raid => {:attendees_string => ''}}
  end
  
  describe "success" do
    before(:each) do
      @live_raid.should_receive(:save).and_return(true)
      put :update, @params
    end
    
    it { should_not set_the_flash }
    it { should redirect_to(live_raid_path(@live_raid)) }
  end
  
  describe "failure" do
    before(:each) do
      @live_raid.should_receive(:save).and_return(false)
      put :update, @params
    end
    
    it { should set_the_flash.to(/failed to update/i) }
    it { should redirect_to(live_raid_path(@live_raid)) }
  end
end

describe Attendance::RaidsController, "GET start" do
  include AttendanceRaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @live_raid.should_receive(:start!)
    get :start, :id => @live_raid.id
  end
  
  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@live_raid)) }
end

describe Attendance::RaidsController, "GET stop" do
  include AttendanceRaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @live_raid.should_receive(:stop!)
    get :stop, :id => @live_raid.id
  end
  
  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@live_raid)) }
end

describe Attendance::RaidsController, "GET post" do
  include AttendanceRaidsHelperMethods
  
  before(:each) do
    login(:admin)
    @live_raid = Factory(:live_raid, :started_at => Time.now, :stopped_at => Time.now)
    mock_find
    mock_xmlrpc
  end
  
  context "completed raid" do
    before(:each) do
      @live_raid.should_receive(:status).and_return('Completed')
      get :post, :id => @live_raid.id
    end
    
    it { should set_the_flash.to(/created attendance thread/) }
    it { should redirect_to(live_raids_path) }
  end
  
  context "active raid" do
    before(:each) do
      @live_raid.should_receive(:status).and_return('Active')
      get :post, :id => @live_raid.id
    end
    
    it { should_not set_the_flash }
    it { should redirect_to(live_raid_path(@live_raid)) }
  end
end