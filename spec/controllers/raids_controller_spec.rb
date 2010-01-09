require 'spec_helper'

module RaidsHelperMethods
  def mock_find
    @raid ||= Factory(:raid)
    Raid.should_receive(:find).with(anything()).and_return(@raid)
  end
  
  def mock_new
    @raid ||= Factory(:raid)
    Raid.should_receive(:new).with(anything()).and_return(@raid)
  end
end

describe RaidsController, "routing" do
  it { should route(:get, '/raids').to(:controller => :raids, :action => :index) }
  it { should route(:get, '/raids/1').to(:controller => :raids, :action => :show, :id => '1') }
  it { should route(:get, '/raids/new').to(:controller => :raids, :action => :new) }
  it { should route(:get, '/raids/1/edit').to(:controller => :raids, :action => :edit, :id => '1') }
  it { should route(:post, '/raids').to(:controller => :raids, :action => :create) }
  it { should route(:put, '/raids/1').to(:controller => :raids, :action => :update, :id => '1') }
  it { should route(:delete, '/raids/1').to(:controller => :raids, :action => :destroy, :id => '1') }
end

describe RaidsController, "GET index" do
  before(:each) do
    login(:admin)
  end
  
  before(:each) do
    get :index
  end

  it { should respond_with(:success) }
  it { should assign_to(:raids).with([]) }
  it { should render_template(:index) }
end

describe RaidsController, "GET show" do
  include RaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    get :show, :id => @raid
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:raid).with(@raid) }
  it { should assign_to(:loots).with([]) }
  it { should assign_to(:attendees) }
  it { should render_template(:show) }
end

describe RaidsController, "GET new" do
  before(:each) do
    login(:admin)
    get :new
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:raid) }
  it { should render_template(:new) }
end

describe RaidsController, "GET edit" do
  include RaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    get :edit, :id => @raid
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:raid).with(@raid) }
  it { should render_template(:edit) }
end

describe RaidsController, "POST create" do
  include RaidsHelperMethods

  before(:each) do
    login(:admin)
    mock_new
  end

  context "success" do
    before(:each) do
      @raid.should_receive(:save).and_return(true)
      post :create, :raid => {}
    end
    
    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(raid_path(@raid)) }
  end
  
  context "failure" do
    before(:each) do
      @raid.should_receive(:save).and_return(false)
      post :create, :raid => {}
    end
    
    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe RaidsController, "PUT update" do
  include RaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
  end
  
  context "success" do
    before(:each) do
      @raid.should_receive(:update_attributes).with(anything()).and_return(true)
      put :update, :id => @raid
    end
    
    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(raid_path(@raid)) }
  end
  
  context "failure" do
    before(:each) do
      @raid.should_receive(:update_attributes).with(anything()).and_return(false)
      put :update, :id => @raid
    end
    
    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe RaidsController, "DELETE destroy" do
  include RaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @raid.should_receive(:destroy)
    delete :destroy, :id => @raid
  end
  
  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(raids_path) }
end