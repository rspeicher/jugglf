require 'spec_helper'

def mock_find(stubs = {})
  @live_raid ||= mock_model(LiveRaid, stubs)
  LiveRaid.should_receive(:find).with(anything()).and_return(@live_raid)
end

def mock_new
  @live_raid = mock_model(LiveRaid)
  LiveRaid.should_receive(:new).and_return(@live_raid)
end

describe Attendance::RaidsController, "#index" do
  describe "basics" do
    before(:each) do
      login(:admin)
      get :index
    end
  
    it { should assign_to(:raids) }
    it { should render_template(:index) }
    it { should respond_with(:success) }
  end
end

describe Attendance::RaidsController, "#show" do
  describe "basics" do
    before(:each) do
      login(:admin)
      mock_find
      get :show, :id => @live_raid.id
    end
    
    it { should assign_to(:live_raid) }
    it { should render_template(:show) }
    it { should respond_with(:success) }
  end
end

describe Attendance::RaidsController, "#new" do
  describe "basics" do
    before(:each) do
      login(:admin)
      get :new
    end
  
    it { should assign_to(:live_raid) }
    it { should render_template(:new) }
    it { should respond_with(:success) }
  end
end

describe Attendance::RaidsController, "#create" do
  before(:each) do
    login(:admin)
    mock_new
    @params = {:live_raid => {:attendees_string => 'Tsigo'}}
  end
  
  describe "success" do
    before(:each) do
      @live_raid.stub!(:save).and_return(true)
      post :create, @params
    end
    
    it { should respond_with(:redirect) }
    it { should redirect_to(live_raid_path(@live_raid)) }
  end
  
  describe "failure" do
    before(:each) do
      @live_raid.stub!(:save).and_return(false)
      post :create, @params
    end
    
    it { should respond_with(:success) }
    it { should render_template(:new) }
  end
end

describe Attendance::RaidsController, "#update" do
  before(:each) do
    login(:admin)
    mock_find('attributes=' => nil)
    @params = {:live_raid => {:attendees_string => 'Tsigo'}}
  end
  
  describe "success" do
    before(:each) do
      @live_raid.stub!(:save).and_return(true)
      put :update, @params
    end
    
    it { should_not set_the_flash }
    it { should redirect_to(live_raid_path(@live_raid)) }
  end
  
  describe "failure" do
    before(:each) do
      @live_raid.stub!(:save).and_return(false)
      put :update, @params
    end
    
    it { should set_the_flash.to(/failed/i) }
    it { should redirect_to(live_raid_path(@live_raid)) }
  end
end

describe Attendance::RaidsController, "#start" do
  before(:each) do
    login(:admin)
    mock_find
    @live_raid.should_receive(:start!)
    get :start, :id => @live_raid.id
  end
  
  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@live_raid)) }
end

describe Attendance::RaidsController, "#stop" do
  before(:each) do
    login(:admin)
    mock_find
    @live_raid.should_receive(:stop!)
    get :stop, :id => @live_raid.id
  end
  
  it { should respond_with(:redirect) }
  it { should redirect_to(live_raid_path(@live_raid)) }
end