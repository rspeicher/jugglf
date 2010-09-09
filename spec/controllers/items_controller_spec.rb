require 'spec_helper'

describe ItemsController, "routing" do
  it { should route(:get,    '/items'       ).to(:controller => :items, :action => :index) }
  it { should route(:post,   '/items'       ).to(:controller => :items, :action => :create) }
  it { should route(:get,    '/items/new'   ).to(:controller => :items, :action => :new) }
  it { should route(:get,    '/items/1/edit').to(:controller => :items, :action => :edit,    :id => '1') }
  it { should route(:get,    '/items/1'     ).to(:controller => :items, :action => :show,    :id => '1') }
  it { should route(:put,    '/items/1'     ).to(:controller => :items, :action => :update,  :id => '1') }
  it { should route(:delete, '/items/1'     ).to(:controller => :items, :action => :destroy, :id => '1') }
end

describe ItemsController, "GET index" do
  before do
    get :index
  end

  it { should respond_with(:success) }
  it { should assign_to(:items).with_kind_of(Array) }
  it { should render_template(:index) }
end

describe ItemsController, "GET show" do
  before do
    @resource = Factory(:item)
    get :show, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:item).with(@resource) }
  it { should assign_to(:loots).with(@resource.loots) }
  it { should assign_to(:wishlists).with(@resource.wishlists) }
  it { should render_template(:show) }
end

describe ItemsController, "GET new" do
  before do
    get :new
  end

  it { should respond_with(:success) }
  it { should assign_to(:item).with_kind_of(Item) }
  it { should render_template(:new) }
end

describe ItemsController, "GET edit" do
  before do
    @resource = Factory(:item)
    get :edit, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:item).with(@resource) }
  it { should render_template(:edit) }
end

describe ItemsController, "POST create" do
  before do
    @resource = Factory.build(:item)
    Item.expects(:new).with({}).returns(@resource)
  end

  context "success" do
    before do
      post :create, :item => {}
    end

    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(item_path(@resource)) }
  end

  context "failure" do
    before do
      @resource.expects(:save).returns(false)
      post :create, :item => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe ItemsController, "PUT update" do
  context "success" do
    before do
      Item.any_instance.expects(:update_attributes).with({}).returns(true)
      put :update, :id => Factory(:item), :item => {}
    end

    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(item_path(@resource)) }
  end

  context "failure" do
    before do
      Item.any_instance.expects(:update_attributes).with({}).returns(false)
      put :update, :id => Factory(:item), :item => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe ItemsController, "DELETE destroy" do
  before do
    @resource = Factory(:item)
    delete :destroy, :id => @resource
  end

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(items_path) }
end
