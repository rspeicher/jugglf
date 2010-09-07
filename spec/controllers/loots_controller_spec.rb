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
  before(:each) do
    login(:admin)
    get :index
  end

  subject { controller }

  it { should respond_with(:success) }
  it { should assign_to(:loots) }
  it { should render_template(:index) }
end

describe LootsController, "GET new" do
  before(:each) do
    login(:admin)
    get :new
  end

  subject { controller }

  it { should respond_with(:success) }
  it { should assign_to(:loot) }
  it { should assign_to(:raids) }
  it { should render_template(:new) }
end

describe LootsController, "GET edit" do
  before(:each) do
    login(:admin)
    mock_find(:loot)
    get :edit, :id => @object
  end

  subject { controller }

  it { should respond_with(:success) }
  it { should assign_to(:loot).with(@object) }
  it { should assign_to(:raids) }
  it { should render_template(:edit) }
end

describe LootsController, "POST create" do
  before(:each) do
    login(:admin)
  end

  subject { controller }

  context "success" do
    before(:each) do
      mock_create(:loot, :save => true)
      post :create, :loot => {}
    end

    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(loots_path) }
  end

  context "failure" do
    before(:each) do
      mock_create(:loot, :save => false)
      post :create, :loot => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe LootsController, "PUT update" do
  before(:each) do
    login(:admin)
  end

  subject { controller }

  context "success" do
    before(:each) do
      mock_find(:loot, :update_attributes => true)
      put :update, :id => @object
    end

    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(loots_path) }
  end

  context "failure" do
    before(:each) do
      mock_find(:loot, :update_attributes => false)
      put :update, :id => @object
    end

    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe LootsController, "DELETE destroy" do
  before(:each) do
    login(:admin)
    mock_find(:loot, :destroy => true)
    delete :destroy, :id => @object
  end

  subject { controller }

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(loots_path) }
end
