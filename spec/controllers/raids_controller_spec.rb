require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_raid, :only => [:show, :edit, :update, :destroy]
def find_raid
  @raid ||= mock_model(Raid, :to_param => '1')
  Raid.should_receive(:find).with('1').and_return(@raid)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /raid/index
describe RaidsController, "#index" do
  def get_response()
    get :index
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      @raid = mock_model(Raid)
      Raid.should_receive(:paginate).and_return(@raid)
      get_response
    end
    
    it "should assign @raids" do
      assigns[:raids].should === @raid
    end
    
    it "should render" do
      response.should render_template(:index)
      response.should be_success
    end
  end
  
  describe "as user" do
    it "should not render" do
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
# Show
# -----------------------------------------------------------------------------

# GET /raids/show/:id
describe RaidsController, "#show" do
  def get_response
    get :show, :id => '1'
  end
  
  describe "as_admin" do
    before(:each) do
      login({}, :is_admin? => true)
      @raid = mock_model(Raid, :attendees => mock_model(Attendee), 
        :items => mock_model(Item))
      @raid.attendees.should_receive(:find).and_return('attendees')
      @raid.items.should_receive(:find).and_return('items')
      
      find_raid
      get_response
    end
    
    it "should assign @attendees" do
      assigns[:attendees].should == 'attendees'
    end
    
    it "should assign @drops" do
      assigns[:drops].should == 'items'
    end
    
    it "should render" do
      response.should render_template(:show)
      response.should be_success
    end
  end
  
  describe "as user" do
    it "should not render" do
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

# GET /raids/new
describe RaidsController, "#new" do
  def get_response
    get :new
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      @raid = mock_model(Raid)
      Raid.should_receive(:new).and_return(@raid)
      get_response
    end
    
    it "should assign @raid" do
      assigns[:raid].should === @raid
    end
    
    it "should render" do
      response.should render_template(:new)
      response.should be_success
    end
  end
  
  describe "as user" do
    it "should not render" do
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
# Create
# -----------------------------------------------------------------------------

# POST /raids/create
describe RaidsController, "#create" do
  def get_response
    post :create, :raid => @params
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      @raid = mock_model(Raid, :to_param => '1')
      Raid.should_receive(:new).and_return(@raid)
    end
    
    describe "when successful" do
      before(:each) do
        @raid.should_receive(:save).and_return(true)
        get_response
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Raid was successfully created.'
      end
      
      it "should redirect to the new raid" do
        response.should redirect_to(raid_url(@raid))
      end
    end
    
    describe "when unsuccessful" do
      it "should render template :new" do
        @raid.should_receive(:save).and_return(false)
        get_response
        response.should render_template(:new)
      end
    end
  end
  
  describe "as user" do
    it "should do nothing" do
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
# Destroy
# -----------------------------------------------------------------------------

# DELETE /raids/:id
describe RaidsController, "#destroy" do
  def get_response
    delete :destroy, :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      find_raid
      @raid.should_receive(:destroy).and_return(nil)
      get_response
    end
    
    it "should add a flash success message" do
      flash[:success].should == 'Raid was successfully deleted.'
    end
    
    it "should redirect to #index" do
      response.should redirect_to(raids_url)
    end
  end
  
  describe "as user" do
    it "should do nothing" do
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