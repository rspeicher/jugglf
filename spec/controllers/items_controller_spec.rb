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
  before(:each) do
    login(:admin)
    get :index
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:items).with_kind_of(Array) }
  it { should render_template(:index) }
end

describe ItemsController, "GET show" do
  before(:each) do
    login(:admin)
    mock_find(:item)
    get :show, :id => @object.id
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:item).with(@object) }
  it { should assign_to(:loots).with(@object.loots) }
  it { should assign_to(:wishlists).with(@object.wishlists) }
  # it { should assign_to(:loot_table) } # FIXME: ???
  it { should render_template(:show) }
end

describe ItemsController, "GET new" do
  before(:each) do
    login(:admin)
    get :new
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:item).with_kind_of(Item) }
  it { should render_template(:new) }
end

describe ItemsController, "GET edit" do
  before(:each) do
    login(:admin)
    mock_find(:item)
    get :edit, :id => @object
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:item).with(@object) }
  it { should render_template(:edit) }
end

describe ItemsController, "POST create" do
  before(:each) do
    login(:admin)
  end

  context "success" do
    before(:each) do
      mock_create(:item, :save => true)
      post :create, :item => {}
    end
    
    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(item_path(@object)) }
  end
  
  context "failure" do
    before(:each) do
      mock_create(:item, :save => false)
      post :create, :item => {}
    end
    
    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe ItemsController, "PUT update" do
  before(:each) do
    login(:admin)
    mock_find(:item)
  end
  
  context "success" do
    before(:each) do
      @object.should_receive(:update_attributes).with(anything()).and_return(true)
      put :update, :id => @object
    end
    
    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(item_path(@object)) }
  end
  
  context "failure" do
    before(:each) do
      @object.should_receive(:update_attributes).with(anything()).and_return(false)
      put :update, :id => @object
    end
    
    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe ItemsController, "DELETE destroy" do
  before(:each) do
    login(:admin)
    mock_find(:item)
    @object.should_receive(:destroy)
    delete :destroy, :id => @object
  end
  
  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(items_path) }
end