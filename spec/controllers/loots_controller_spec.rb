require 'spec_helper'

describe LootsController, "routing" do
  it { should route(:get,    '/loots'        ).to(:controller => :loots, :action => :index) }
  it { should route(:post,   '/loots'        ).to(:controller => :loots, :action => :create) }
  it { should route(:get,    '/loots/new'    ).to(:controller => :loots, :action => :new) }
  it { should route(:get,    '/loots/1/edit' ).to(:controller => :loots, :action => :edit,    :id => '1') }
  it { should route(:get,    '/loots/1/price').to(:controller => :loots, :action => :price,   :id => '1') } # TODO: Don't need this anymore?
  it { should route(:put,    '/loots/1'      ).to(:controller => :loots, :action => :update,  :id => '1') }
  it { should route(:delete, '/loots/1'      ).to(:controller => :loots, :action => :destroy, :id => '1') }
end

describe LootsController, "GET index" do
  before do
    get :index
  end

  it { should respond_with(:success) }
  it { should assign_to(:loots) }
  it { should render_template(:index) }
end

describe LootsController, "GET new" do
  before do
    get :new
  end

  it { should respond_with(:success) }
  it { should assign_to(:loot).with_kind_of(Loot) }
  it { should assign_to(:raids) }
  it { should render_template(:new) }
end

describe LootsController, "GET edit" do
  before do
    @resource = Factory(:loot)
    get :edit, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:loot).with(@resource) }
  it { should assign_to(:raids) }
  it { should render_template(:edit) }
end

describe LootsController, "POST create" do
  before do
    @resource = Factory.build(:loot)
    Loot.expects(:new).with({}).returns(@resource)
  end

  context "success" do
    before do
      post :create, :loot => {}
    end

    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(loots_path) }
  end

  context "failure" do
    before do
      @resource.expects(:save).returns(false)
      post :create, :loot => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe LootsController, "PUT update" do
  context "success" do
    before do
      Loot.any_instance.expects(:update_attributes).with({}).returns(true)
      put :update, :id => Factory(:loot), :loot => {}
    end

    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(loots_path) }
  end

  context "failure" do
    before do
      Loot.any_instance.expects(:update_attributes).with({}).returns(false)
      put :update, :id => Factory(:loot), :loot => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe LootsController, "DELETE destroy" do
  before do
    @resource = Factory(:loot)
    delete :destroy, :id => @resource
  end

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(loots_path) }
end
