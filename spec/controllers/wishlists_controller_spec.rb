require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def find_wishlist
  @wishlist ||= mock_model(Wishlist, :to_param => '1')
  Wishlist.should_receive(:find).with('1').and_return(@wishlist)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /wishlists
describe WishlistsController, "#index" do
  def get_response
    get :index
  end
  
  describe "as user" do
    before(:each) do
      login
    end
    
    it "should render" do
      get_response
      response.should render_template(:index)
      response.should be_success
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      logout
      get_response
      response.should redirect_to(new_user_session_url)
    end
  end
end

# -----------------------------------------------------------------------------
# New
# -----------------------------------------------------------------------------

# GET /wishlists/new
describe WishlistsController, "#new" do
  def get_response
    get :new
  end
  
  describe "as user" do
    before(:each) do
      Wishlist.should_receive(:new).and_return('wishlist')
      login
      get_response
    end
    
    it "should assign @wishlist" do
      assigns[:wishlist].should == 'wishlist'
    end
    
    it "should render" do
      response.should render_template(:new)
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      logout
      get_response
      response.should redirect_to(new_user_session_url)
    end
  end
end

# -----------------------------------------------------------------------------
# Create
# -----------------------------------------------------------------------------

# POST /members
describe WishlistsController, "#create" do
  def get_response
    post :create, :wishlist => @params
  end
  
  describe "as user" do
    describe "when successful" do
      before(:each) do
        login
        @wishlist = mock_model(Wishlist, :to_param => '1', :save => true)
        @params = Wishlist.plan.stringify_keys!
        Wishlist.should_receive(:new).with(@params).and_return(@wishlist)
        get_response
      end
      
      it "should create a new wishlist from params" do
        assigns[:wishlist].should == @wishlist
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Wishlist entry was successfully created.'
      end

      it "should redirect to the new wishlist" do
        response.should redirect_to(wishlists_url)
      end
    end

    describe "when unsuccessful" do
      before(:each) do
        login
        @wishlist = mock_model(Wishlist, :save => false)
        Wishlist.stub!(:new).and_return(@wishlist)
      end

      it "should render template :new" do
        get_response
        response.should render_template(:new)
      end
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      logout
      get_response
      response.should redirect_to(new_user_session_url)
    end
  end
end

describe WishlistsController, "#create XHR" do
  def xhr_request
    xhr :post, :create, :wishlist => @params
  end
  
  # We don't test As User/As Anonymous, we expect the non-XHR spec to do that
  
  describe "when successful" do
    it "should be successful"
  end
  
  describe "when unsuccessful" do
    it "should do something"
  end
end

# -----------------------------------------------------------------------------
# Destroy
# -----------------------------------------------------------------------------

# DELETE /wishlists/:id
describe WishlistsController, "#destroy" do
  def get_response
    delete :destroy, :id => '1'
  end
  def xhr_response
    xhr :delete, :destroy, :id => '1'
  end
  
  describe "as user" do
    before(:each) do
      login
      find_wishlist
      @wishlist.should_receive(:destroy).and_return(nil)
    end
    
    describe "for HTML" do
      before(:each) do
        get_response
      end
    
      it "should add a flash success message" do
        flash[:success].should == 'Wishlist entry was successfully deleted.'
      end
    
      it "should redirect to #index" do
        response.should redirect_to(wishlists_path)
      end
    end
    
    describe "for Javascript" do
      it "should be successful" do
        xhr_response
        response.should be_success
      end
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      logout
      get_response
      response.should redirect_to(new_user_session_url)
    end
  end
end