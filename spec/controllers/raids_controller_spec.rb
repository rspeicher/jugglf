require 'spec_helper'

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
  before(:each) do
    login(:admin)
    mock_find(:raid)
    get :show, :id => @object
  end

  it { should respond_with(:success) }
  it { should assign_to(:raid).with(@object) }
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
  before(:each) do
    login(:admin)
    mock_find(:raid)
    get :edit, :id => @object
  end

  it { should respond_with(:success) }
  it { should assign_to(:raid).with(@object) }
  it { should render_template(:edit) }
end

describe RaidsController, "POST create" do
  before(:each) do
    login(:admin)
  end

  context "success" do
    before(:each) do
      mock_create(:raid, :save => true)
      post :create, :raid => {}
    end

    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(raid_path(@object)) }
  end

  context "failure" do
    before(:each) do
      mock_create(:raid, :save => false)
      post :create, :raid => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe RaidsController, "PUT update" do
  before(:each) do
    login(:admin)
  end

  context "success" do
    before(:each) do
      mock_find(:raid, :update_attributes => true)
      put :update, :id => @object
    end

    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(raid_path(@object)) }
  end

  context "failure" do
    before(:each) do
      mock_find(:raid, :update_attributes => false)
      put :update, :id => @object
    end

    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe RaidsController, "DELETE destroy" do
  before(:each) do
    login(:admin)
    mock_find(:raid, :destroy => true)
    delete :destroy, :id => @object
  end

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(raids_path) }
end