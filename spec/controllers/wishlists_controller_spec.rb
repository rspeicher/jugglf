require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_parent
# FIXME: When this mock didn't include :punishments, and when the Punishment
# version didn't include :wishlists, a ton of these examples would fail when one
# was run right after the other. I gave up trying to figure out why and just
# included them both.
def find_parent
  @parent ||= @member ||= mock_model(Member, :to_param => '1', 
    :punishments => mock_model(Punishment), :wishlists => mock_model(Wishlist))
  Member.should_receive(:find).with('1').and_return(@parent)
end

# before_filter :find_wishlist, :only => [:edit, :update, :destroy]
def find_wishlist
  @wishlist ||= @member.wishlists
  @member.wishlists.should_receive(:find).with('1').and_return(@wishlist)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /wishlists
describe WishlistsController, "#index" do
  def get_response
    get :index
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
    end
    
    it "should assign @root"
    
    it "should assign @zone"
    
    it "should render"
    
    describe ":boss parameter" do
      it "should assign @items"
      
      it "should re-assign @zone"
      
      it "should still assign @items if not present"
    end
  end
  
  describe "as user" do
    it "should redirect to /todo" do
      login({}, :is_admin? => false)
      get_response
      response.should redirect_to('/todo')
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
    get :new, :member_id => '1'
  end
  
  describe "as user" do
    before(:each) do
      login
      find_parent
      @member.wishlists.should_receive(:new).and_return('wishlist')
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
    get :edit, :member_id => '1', :id => '1'
  end
  
  describe "as user" do
    before(:each) do
      login
      find_parent
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
      post :create, :member_id => '1', :wishlist => @params
    elsif type == :xhr
      xhr :post, :create, :member_id => '1', :wishlist => @params
    end
  end
  
  describe "as user" do
    describe "when successful" do
      before(:each) do
        find_parent
        login
        @wishlist = mock_model(Wishlist, :to_param => '1', :save => true)
        @params = Wishlist.plan(:member => @parent).stringify_keys!
        @parent.wishlists.should_receive(:new).with(@params).and_return(@wishlist)
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
          response.should render_template(:create)
        end
      end
    end

    describe "when unsuccessful" do
      before(:each) do
        login
        find_parent
        @wishlist = mock_model(Wishlist, :save => false)
        @parent.wishlists.stub!(:new).and_return(@wishlist)
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
          response.should render_template(:create)
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

# PUT /wishlists/:id
describe WishlistsController, "#update" do
  def get_response(type = :normal)
    if type == :normal
      put :update, :member_id => '1', :id => '1', :wishlist => @params
    elsif type == :xhr
      xhr :put, :update, :member_id => '1', :id => '1', :wishlist => @params
    end
  end
  
  describe "as user" do
    before(:each) do
      find_parent
      find_wishlist
      @params = Wishlist.plan(:member => @parent).stringify_keys!
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
      delete :destroy, :member_id => '1', :id => '1'
    elsif type == :xhr
      xhr :delete, :destroy, :member_id => '1', :id => '1'
    end
  end
  
  describe "as user" do
    before(:each) do
      login
      find_parent
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