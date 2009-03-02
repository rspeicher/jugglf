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
# Edit
# -----------------------------------------------------------------------------

# GET /wishlists/:id
describe WishlistsController, "#edit" do
  def get_response
    get :edit, :id => '1'
  end
  
  describe "as user" do
    before(:each) do
      login
      find_wishlist
      get_response
    end
    
    it "should assign @wishlist" do
      assigns[:wishlist].should == @wishlist
    end
    
    it "should render" do
      response.should render_template(:edit)
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
  def get_response(type = :normal)
    if type == :normal
      post :create, :wishlist => @params
    elsif type == :xhr
      xhr :post, :create, :wishlist => @params
    end
  end
  
  describe "as user" do
    describe "when successful" do
      before(:each) do
        login
        @wishlist = mock_model(Wishlist, :to_param => '1', :save => true)
        @params = Wishlist.plan.stringify_keys!
        Wishlist.should_receive(:new).with(@params).and_return(@wishlist)
      end
      
      describe "wanting HTML" do
        before(:each) do
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
      
      describe "wanting JS" do
        it "should be successful" do
          get_response(:xhr)
          response.should render_template(:create_success)
        end
      end
    end

    describe "when unsuccessful" do
      before(:each) do
        login
        @wishlist = mock_model(Wishlist, :save => false)
        Wishlist.stub!(:new).and_return(@wishlist)
      end
      
      describe "wanting HTML" do
        it "should render template :new" do
          get_response
          response.should render_template(:new)
        end
      end
      
      describe "wanting JS" do
        it "should render template :create_failure" do
          get_response(:xhr)
          response.should render_template(:create_failure)
        end
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

# -----------------------------------------------------------------------------
# Update
# -----------------------------------------------------------------------------

# POST /wishlists/:id
describe WishlistsController, "#update" do
  def get_response(type = :normal)
    if type == :normal
      post :update, :id => '1', :wishlist => @params
    elsif type == :xhr
      xhr :post, :update, :id => '1', :wishlist => @params
    end
  end
  
  describe "as user" do
    before(:each) do
      find_wishlist
      @params = Wishlist.plan.stringify_keys!
    end
    
    describe "when successful" do
      before(:each) do
        login
        @wishlist.should_receive(:update_attributes).with(@params).and_return(true)
      end
      
      describe "wanting HTML" do
        before(:each) do
          get_response
        end
        
        it "should add a flash success message" do
          flash[:success].should == 'Wishlist entry was successfully updated.'
        end
        
        it "should redirect to wishlists_path" do
          response.should redirect_to(wishlists_path)
        end
      end
      
      describe "wanting JS" do
      end
    end
    
    describe "when unsuccessful" do
      before(:each) do
        login
        @wishlist.should_receive(:update_attributes).with(@params).and_return(false)
      end
      
      describe "wanting HTML" do
        it "should render :edit" do
          get_response
          response.should render_template(:edit)
        end
      end
      
      describe "wanting JS" do
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

# -----------------------------------------------------------------------------
# Destroy
# -----------------------------------------------------------------------------

# DELETE /wishlists/:id
describe WishlistsController, "#destroy" do
  def get_response(type = :normal)
    if type == :normal
      delete :destroy, :id => '1'
    elsif type == :xhr
      xhr :delete, :destroy, :id => '1'
    end
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
        get_response(:xhr)
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