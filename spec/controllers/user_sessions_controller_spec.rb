require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# -----------------------------------------------------------------------------
# New
# -----------------------------------------------------------------------------

# GET /user_session/new
describe UserSessionsController, "#new" do
  def get_response
    get :new
  end
  
  describe "when logged in" do
    it "should redirect somewhere else" do
      login
      get_response
      response.should redirect_to(root_path)
    end
  end
  
  describe "when logged out" do
    it "should assign @user_session" do
      get_response
      response.should_not redirect_to(root_url)
      assigns[:user_session].should_not be_nil
    end
  end
end

# -----------------------------------------------------------------------------
# Create
# -----------------------------------------------------------------------------

# POST /user_session
describe UserSessionsController, "#create" do
  def get_response
    post :create, :user_session => {}
  end
  
  describe "when logged in" do
    it "should redirect somewhere else" do
      login
      get_response
      response.should redirect_to(root_path)
    end
  end
  
  describe "when logged out" do
    describe "when successful" do
      before(:each) do
        @user = mock_model(UserSession, :save => true)
        UserSession.stub!(:find).and_return(nil) # current_user_session
        UserSession.should_receive(:new).and_return(@user)
        get_response
      end
      
      it "should assign @user_session" do
        assigns[:user_session].should_not be_nil
      end
    
      it "should add a flash success message" do
        flash[:success].should == 'Login successful!'
      end
      
      it "should redirect back to default of members_url" do
        response.should redirect_to(members_url)
      end
    end
    
    describe "when unsuccessful" do
      it "should render action :new" do
        get_response
        response.should render_template(:new)
      end
    end
  end
end

# -----------------------------------------------------------------------------
# Destroy
# -----------------------------------------------------------------------------

# DELETE /user_session
describe UserSessionsController, "#destroy" do
  def get_response
    delete :destroy
  end
  
  describe "when logged in" do
    before(:each) do
      login
      get_response
    end
    
    # NOTE: I don't know how we should add an expection for should_receive(:destroy)
    # on current_user_session since we can't access that method here
    it "should destroy the current session" do
    end
    
    it "should add a flash success message" do
      flash[:success].should == 'Logout successful.'
    end
    
    it "should redirect to root_url" do
      response.should redirect_to(root_url)
    end
  end
  
  describe "when logged out" do
    it "should redirect to new_user_session_url" do
      get_response
      response.should redirect_to(new_user_session_url)
    end
  end
end