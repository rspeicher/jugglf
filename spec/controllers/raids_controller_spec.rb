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
  before do
    get :index
  end

  it { should respond_with(:success) }
  it { should assign_to(:raids) }
  it { should render_template(:index) }
end

describe RaidsController, "GET show" do
  before do
    @resource = Factory(:raid)
    get :show, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:raid).with(@resource) }
  it { should assign_to(:loots) }
  it { should assign_to(:attendees) }
  it { should render_template(:show) }
end

describe RaidsController, "GET new" do
  before do
    get :new
  end

  it { should respond_with(:success) }
  it { should assign_to(:raid).with_kind_of(Raid) }
  it { should render_template(:new) }
end

describe RaidsController, "GET edit" do
  before do
    @resource = Factory(:raid)
    get :edit, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:raid).with(@resource) }
  it { should render_template(:edit) }
end

describe RaidsController, "POST create" do
  before do
    @resource = Factory.build(:raid)
    Raid.expects(:new).with({}).returns(@resource)
  end

  context "success" do
    before do
      post :create, :raid => {}
    end

    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(raid_path(@resource)) }
  end

  context "failure" do
    before do
      @resource.expects(:save).returns(false)
      post :create, :raid => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe RaidsController, "PUT update" do
  context "success" do
    before do
      Raid.any_instance.expects(:update_attributes).with({}).returns(true)
      put :update, :id => Factory(:raid), :raid => {}
    end

    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(raid_path(@resource)) }
  end

  context "failure" do
    before do
      Raid.any_instance.expects(:update_attributes).with({}).returns(false)
      put :update, :id => Factory(:raid), :raid => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe RaidsController, "DELETE destroy" do
  before do
    @resource = Factory(:raid)
    delete :destroy, :id => @resource
  end

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(raids_path) }
end
