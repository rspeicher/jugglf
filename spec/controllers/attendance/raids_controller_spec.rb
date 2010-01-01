require 'spec_helper'

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
      
      @live_raid = mock_model(LiveRaid)
      LiveRaid.should_receive(:find).with(anything()).and_return(@live_raid)
      
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
    
    @live_raid = mock_model(LiveRaid)
    LiveRaid.should_receive(:new).and_return(@live_raid)
    
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