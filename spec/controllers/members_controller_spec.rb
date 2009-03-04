require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_member, :only => [:show, :edit, :update, :destroy]
def find_member
  @member ||= mock_model(Member, :to_param => '1')
  Member.should_receive(:find).with('1').and_return(@member)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /members/index
describe MembersController, "#index" do
  def get_response(args = {})
    get :index, args
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      Member.should_receive(:find_all_by_active).and_return(nil)
    end
    
    it "should render" do
      get_response
      response.should render_template(:index)
      response.should be_success
    end
    
    it "should render lua" do
      get_response(:format => 'lua')
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

# GET /members/:id
describe MembersController, "#show" do
  def get_response
    get :show, :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      
      @mock = mock_model(Member, 
        :punishments => mock_model(Punishment, :find_all_active => 'punishments'),
        :loots => mock_model(Loot, :find => 'loots'))
      Member.should_receive(:find).with('1', anything()).and_return(@mock)

      Raid.should_receive(:count).and_return(0)
      Raid.should_receive(:paginate).and_return('raids')

      get_response
    end

    it "should assign @member" do
      assigns[:member].should == @mock
    end

    it "should assign @raids_count" do
      assigns[:raids_count].should == 0
    end

    it "should assign @raids" do
      assigns[:raids].should == 'raids'
    end
    
    it "should assign @loots" do
      assigns[:loots].should == 'loots'
    end

    it "should assign @punishments" do
      assigns[:punishments].should == 'punishments'
    end
    
    it "should render" do
      response.should render_template(:show)
      response.should be_success
    end
  end
  
  describe "as user" do
    before(:each) do
      login({}, :is_admin? => false)
    end
    
    it "should not render if the member doesn't belong to the current user"
    
    it "should render when the current member belongs to the current user"
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

# GET /members/new
describe MembersController, "#new" do
  def get_response
    get :new
  end
  
  describe "as admin" do
    before(:each) do
      Member.should_receive(:new).and_return(nil)
    end
    
    it "should render" do
      login({}, :is_admin? => true)
      get_response
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
# Edit
# -----------------------------------------------------------------------------

# GET /members/edit/:id
describe MembersController, "#edit" do
  def get_response
    get :edit, :id => '1'
  end
  
  before(:each) do
    find_member
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      get_response
    end    

    it "should assign @member" do
      assigns[:member].should === @member
    end
    
    it "should render" do
      response.should render_template(:edit)
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

# POST /members
describe MembersController, "#create" do
  def get_response
    post :create, :member => @params
  end
  
  describe "as admin" do
    describe "when successful" do
      before(:each) do
        login({}, :is_admin? => true)
        @member = mock_model(Member, :to_param => '1', :save => true)
        @params = Member.plan.stringify_keys!
        Member.should_receive(:new).with(@params).and_return(@member)
        get_response
      end
      
      it "should create a new member from params" do
        # All handled by before
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Member was successfully created.'
      end
    
      it "should redirect to the new member" do
        response.should redirect_to(member_url('1'))
      end
    end
  
    describe "when unsuccessful" do
      before(:each) do
        login({}, :is_admin? => true)
        @member = mock_model(Member, :save => false)
        Member.stub!(:new).and_return(@member)
      end
    
      it "should render template :new" do
        get_response
        response.should render_template(:new)
      end
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
# Update
# -----------------------------------------------------------------------------

# PUT /members/:id
describe MembersController, "#update" do
  def get_response
    put :update, :id => '1', :member => @params
  end
  
  before(:each) do
    find_member
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      @params = Member.plan.stringify_keys!
    end
    
    describe "when successful" do
      before(:each) do
        @member.should_receive(:update_attributes).with(@params).and_return(true)
        get_response
      end
      
      it "should assign @member from params" do
        assigns[:member].should == @member
      end
      
      it "should update attributes from params" do
        # All handled by before
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Member was successfully updated.'
      end
      
      it "should redirect back to the member" do
        response.should redirect_to(member_url('1'))
      end
    end
    
    describe "when unsuccessful" do
      it "should render the edit form" do
        @member.should_receive(:update_attributes).and_return(false)
        get_response
        response.should render_template(:edit)
      end
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
# Destroy
# -----------------------------------------------------------------------------

describe MembersController, "DELETE /members/:id" do
end