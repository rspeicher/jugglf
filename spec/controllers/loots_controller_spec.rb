require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_loot, :only => [:show, :edit, :update, :destroy]
def find_loot
  @loot ||= mock_model(Loot, :to_param => '1', :purchased_on => Date.today)
  Loot.should_receive(:find).with('1').and_return(@loot)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /loots/index
describe LootsController, "#index" do
  def get_response()
    get :index
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      @loot = mock_model(Loot)
      Loot.should_receive(:paginate).and_return(@loot)
      get_response
    end
    
    it "should assign @loots" do
      assigns[:loots].should === @loot
    end
    
    it "should render" do
      response.should render_template(:index)
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
end

# -----------------------------------------------------------------------------
# New
# -----------------------------------------------------------------------------

# GET /loots/new
describe LootsController, "#new" do
  def get_response
    get :new
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      @loot = mock_model(Loot)
      Loot.should_receive(:new).and_return(@loot)
      get_response
    end
    
    it "should assign @loot" do
      assigns[:loot].should === @loot
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
      response.should redirect_to(new_user_session_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Edit
# -----------------------------------------------------------------------------

# GET /loots/:id/edit
describe LootsController, "#edit" do
  def get_response
    get :edit, :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      @item = mock_model(Item, :name => 'Name', :purchased_on => Date.today)
      find_loot
      get_response
    end
    
    it "should assign @loot" do
      assigns[:loot].should == @loot
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
      response.should redirect_to(new_user_session_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Create
# -----------------------------------------------------------------------------

# POST /loots/create
describe LootsController, "#create" do
  def get_response
    post :create, :loot => @params
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      @loot = mock_model(Loot, :to_param => '1', :purchased_on => Date.today)
      Loot.should_receive(:new).and_return(@loot)
    end
    
    describe "when successful" do
      before(:each) do
        @loot.should_receive(:save).and_return(true)
        get_response
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Loot was successfully created.'
      end
      
      it "should redirect to the new loot" do
        response.should redirect_to(loots_url)
      end
    end
    
    describe "when unsuccessful" do
      it "should render template :new" do
        @loot.should_receive(:save).and_return(false)
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
      response.should redirect_to(new_user_session_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Update
# -----------------------------------------------------------------------------

# PUT /loots/:id
describe LootsController, "#update" do
  def get_response
    put :update, :id => '1', :loot => @params
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      find_loot
      @params = Loot.plan(:raid => mock_model(Raid), :item => mock_model(Item)).stringify_keys!
    end
    
    describe "when successful" do
      before(:each) do
        @loot.should_receive(:update_attributes).with(@params).and_return(true)
        get_response
      end
      
      it "should assign @loot from params" do
        assigns[:loot].should === @loot
      end
      
      it "should update attributes from params" do
        # All handled by before
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Loot was successfully updated.'
      end
      
      it "should redirect back to the loot" do
        response.should redirect_to(loots_url)
      end
    end
    
    describe "when unsuccessful" do
      it "should render the edit form" do
        @loot.should_receive(:update_attributes).and_return(false)
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
      response.should redirect_to(new_user_session_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Destroy
# -----------------------------------------------------------------------------

# DELETE /loots/:id
describe LootsController, "#destroy" do
  def get_response
    delete :destroy, :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      find_loot
      @loot.should_receive(:destroy).and_return(nil)
      get_response
    end
    
    it "should add a flash success message" do
      flash[:success].should == 'Loot was successfully deleted.'
    end
    
    it "should redirect to #index" do
      response.should redirect_to(loots_url)
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
      response.should redirect_to(new_user_session_url)
    end
  end
end