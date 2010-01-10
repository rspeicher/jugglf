require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_item, :only => [:show, :edit, :update, :destroy]
def find_item
  @item ||= mock_model(Item, :to_param => '1', :name => 'Name')
  Item.should_receive(:find).with('1').and_return(@item)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /items
describe ItemsController, "#index" do
  def get_response
    get :index
  end
  
  it "should render" do
    Item.should_receive(:paginate).and_return('Item')
    get_response
    response.should render_template(:index)
  end
end

# -----------------------------------------------------------------------------
# Show
# -----------------------------------------------------------------------------

# GET /items/:id
describe ItemsController, "#show" do
  def get_response
    get :show, :id => '1'
  end
  
  before(:each) do
    login(:admin)
    
    # Set up @item before find_item so we get the stubs we want
    @loot        = mock_model(Loot)
    @wishlist    = mock_model(Wishlist)
    @item        = mock_model(Item, :to_param => '1', :loots => @loot, 
      :wishlists => @wishlist, :name => 'Name')
    @loot_table  = mock_model(LootTable)
    find_item
    
    @item.should_not_receive(:lookup)
    @loot.should_receive(:paginate).and_return([@loot])
    @wishlist.should_receive(:find).and_return([@wishlist])
    LootTable.should_receive(:find).and_return(@loot_table)
    
    get_response
  end
  
  it "should assign @loots" do
    assigns[:loots].should == [@loot]
  end
  
  it "should assign @wishlists" do
    assigns[:wishlists].should == [@wishlist]
  end
  
  it "should render" do
    response.should render_template(:show)
    response.should be_success
  end
end

# -----------------------------------------------------------------------------
# New
# -----------------------------------------------------------------------------

# GET /items/new
describe ItemsController, "#new" do
  def get_response
    get :new
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      @item = mock_model(Item)
      Item.should_receive(:new).and_return(@item)
      get_response
    end
    
    it "should assign @item" do
      assigns[:item].should === @item
    end
    
    it "should render" do
      response.should render_template(:new)
      response.should be_success
    end
  end
  
  describe "as user" do
    it "should not render" do
      login
      get_response
      response.should redirect_to(root_url)
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      get_response
      response.should redirect_to(login_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Edit
# -----------------------------------------------------------------------------

# GET /items/:id/edit
describe ItemsController, "#edit" do
  def get_response
    get :edit, :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      find_item
      get_response
    end
    
    it "should assign @item" do
      assigns[:item].should == @item
    end
    
    it "should render" do
      response.should render_template(:edit)
    end
  end
  
  describe "as user" do
    it "should not render" do
      login
      get_response
      response.should redirect_to(root_url)
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      get_response
      response.should redirect_to(login_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Create
# -----------------------------------------------------------------------------

# POST /items/create
describe ItemsController, "#create" do
  def get_response
    post :create, :item => @params
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      @item = mock_model(Item, :to_param => '1')
      Item.should_receive(:new).and_return(@item)
    end
    
    describe "when successful" do
      before(:each) do
        @item.should_receive(:save).and_return(true)
        get_response
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Item was successfully created.'
      end
      
      it "should redirect to the new item" do
        response.should redirect_to(item_url(@item))
      end
    end
    
    describe "when unsuccessful" do
      it "should render template :new" do
        @item.should_receive(:save).and_return(false)
        get_response
        response.should render_template(:new)
      end
    end
  end
  
  describe "as user" do
    it "should do nothing" do
      login
      get_response
      response.should redirect_to(root_url)
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      get_response
      response.should redirect_to(login_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Update
# -----------------------------------------------------------------------------

# PUT /items/:id
describe ItemsController, "#update" do
  def get_response
    put :update, :id => '1', :item => @params
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      find_item
      @params = Item.plan.stringify_keys!
    end
    
    describe "when successful" do
      before(:each) do
        @item.should_receive(:update_attributes).with(@params).and_return(true)
        get_response
      end
      
      it "should assign @item from params" do
        assigns[:item].should === @item
      end
      
      it "should update attributes from params" do
        # All handled by before
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Item was successfully updated.'
      end
      
      it "should redirect back to the item" do
        response.should redirect_to(item_url('1'))
      end
    end
    
    describe "when unsuccessful" do
      it "should render the edit form" do
        @item.should_receive(:update_attributes).and_return(false)
        get_response
        response.should render_template(:edit)
      end
    end
  end
  
  describe "as user" do
    it "should not render" do
      login
      get_response
      response.should redirect_to(root_url)
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      get_response
      response.should redirect_to(login_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Destroy
# -----------------------------------------------------------------------------

# DELETE /items/:id
describe ItemsController, "#destroy" do
  def get_response
    delete :destroy, :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      find_item
      @item.should_receive(:destroy).and_return(nil)
      get_response
    end
    
    it "should add a flash success message" do
      flash[:success].should == 'Item was successfully deleted.'
    end
    
    it "should redirect to #index" do
      response.should redirect_to(items_url)
    end
  end
  
  describe "as user" do
    it "should do nothing" do
      login
      get_response
      response.should redirect_to(root_url)
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      get_response
      response.should redirect_to(login_url)
    end
  end
end