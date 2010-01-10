require 'spec_helper'

module ItemsHelperMethods
  def mock_find
    @item ||= Factory(:item)
    Item.should_receive(:find).with(anything()).and_return(@item)
  end
  
  def mock_create(expects = {})
    @item ||= Factory(:item)
    Item.should_receive(:new).with(anything()).and_return(@item)
    
    expects.each_pair do |msg, val|
      @item.should_receive(msg).and_return(val)
    end
  end
end

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
  include ItemsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    get :show, :id => @item.id
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:item).with(@item) }
  it { should assign_to(:loots).with(@item.loots) }
  it { should assign_to(:wishlists).with(@item.wishlists) }
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
  include ItemsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    get :edit, :id => @item
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:item).with(@item) }
  it { should render_template(:edit) }
end

describe ItemsController, "POST create" do
  include ItemsHelperMethods

  before(:each) do
    login(:admin)
  end

  context "success" do
    before(:each) do
      mock_create(:save => true)
      post :create, :item => {}
    end
    
    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(item_path(@item)) }
  end
  
  context "failure" do
    before(:each) do
      mock_create(:save => false)
      post :create, :item => {}
    end
    
    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe ItemsController, "PUT update" do
  include ItemsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
  end
  
  context "success" do
    before(:each) do
      @item.should_receive(:update_attributes).with(anything()).and_return(true)
      put :update, :id => @item
    end
    
    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(item_path(@item)) }
  end
  
  context "failure" do
    before(:each) do
      @item.should_receive(:update_attributes).with(anything()).and_return(false)
      put :update, :id => @item
    end
    
    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe ItemsController, "DELETE destroy" do
  include ItemsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @item.should_receive(:destroy)
    delete :destroy, :id => @item
  end
  
  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(items_path) }
end