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
  before(:each) do
    login(:admin)
    get :index
  end

  it { should assign_to(:raids).with_kind_of(Array) }
  it { should render_template(:index) }
  it { should respond_with(:success) }
end

describe Attendance::RaidsController, "GET show" do
  before(:each) do
    login(:admin)
    mock_find(:live_raid)
    get :show, :id => @object.id
  end
  
  it { should assign_to(:live_raid).with_kind_of(LiveRaid) }
  it { should render_template(:show) }
  it { should respond_with(:success) }
end

describe Attendance::RaidsController, "GET new" do
  before(:each) do
    login(:admin)
    get :new
  end

  it { should assign_to(:live_raid).with_kind_of(LiveRaid) }
  it { should render_template(:new) }
  it { should respond_with(:success) }
end

describe Attendance::RaidsController, "POST create" do
  before(:each) do
    login(:admin)
  end
  
  context "success" do
    before(:each) do
      mock_create(:live_raid, :save => true)
      post :create, :live_raid => {:attendees_string => ''}
    end
    
    it { should respond_with(:redirect) }
    it { should redirect_to(live_raid_path(@object)) }
  end
  
  context "failure" do
    before(:each) do
      mock_create(:live_raid, :save => false)
      post :create, :live_raid => {:attendees_string => ''}
    end
    
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end
end

describe Attendance::RaidsController, "PUT update" do
  before(:each) do
    login(:admin)
  end
  
  context "success" do
    before(:each) do
      mock_find(:live_raid, :save => true)
      put :update, :id => @object.id, :live_raid => {:attendees_string => ''}
    end
    
    it { should_not set_the_flash }
    it { should redirect_to(live_raid_path(@object)) }
  end
  
  context "failure" do
    before(:each) do
      mock_find(:live_raid, :save => false)
      put :update, :id => @object.id, :live_raid => {:attendees_string => ''}
    end
    
    it { should set_the_flash.to(/failed to update/i) }
    it { should redirect_to(live_raid_path(@object)) }
  end
end

describe Attendance::RaidsController, "DELETE destroy" do
  before(:each) do
    login(:admin)
    mock_find(:live_raid, :destroy => true)
    delete :destroy, :id => @object
  end
  
  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(live_raids_path) }
end

describe Attendance::RaidsController, "GET start" do
  before(:each) do
    login(:admin)
    mock_find(:live_raid, :start! => true)
    get :start, :id => @object.id
  end
  
  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@object)) }
end

describe Attendance::RaidsController, "GET stop" do
  before(:each) do
    login(:admin)
    mock_find(:live_raid, :stop! => true)
    get :stop, :id => @object.id
  end
  
  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@object)) }
end

describe Attendance::RaidsController, "GET post" do
  before(:each) do
    login(:admin)
    @object = Factory(:live_raid, :started_at => Time.now, :stopped_at => Time.now)
  end
  
  context "completed raid" do
    before(:each) do
      require 'xmlrpc/client'
      server = mock('Server')
      XMLRPC::Client.stub!(:new2).and_return(server)
      server.stub!(:call).and_return({})
      
      mock_find(:live_raid, :status => 'Completed')
      get :post, :id => @object.id
    end
    
    it { should set_the_flash.to(/created attendance thread/) }
    it { should redirect_to(live_raids_path) }
  end
  
  context "active raid" do
    before(:each) do
      mock_find(:live_raid, :status => 'Active')
      get :post, :id => @object.id
    end
    
    it { should_not set_the_flash }
    it { should redirect_to(live_raid_path(@object)) }
  end
end