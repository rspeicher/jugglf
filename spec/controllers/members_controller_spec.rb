require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

describe MembersController, "GET /members/index" do
  def do_get(args = {})
    get :index, args
  end
  
  before(:each) do
    Member.should_receive(:find_all_by_active).and_return(nil)
  end
  
  describe "as admin" do
    it "should render" do
      do_get
      response.should be_success
    end
  end
  
  # describe "as user" do
  #   it "should not render"
  # end
  
  describe ".lua" do
    describe "as admin" do
      it "should render" do
        do_get(:format => 'lua')
        response.should be_success      
      end
    end
    
    # describe "as user" do
    #   it "should not render"
    # end
  end
end

# -----------------------------------------------------------------------------
# Show
# -----------------------------------------------------------------------------

describe MembersController, "GET /members/:id" do
  def do_get
    get :show, :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      @mock = mock_model(Member, 
        :punishments => mock_model(Punishment, :find_all_active => 'punishments'))
      Member.should_receive(:find).with('1').and_return(@mock)

      Raid.should_receive(:count).and_return(0)
      Raid.should_receive(:paginate).and_return('raids')

      do_get
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

    it "should assign @punishments" do
      assigns[:punishments].should == 'punishments'
    end
    
    it "should render" do
      response.should be_success
    end
  end
  
  # describe "as user" do
  #   it "should not render if the member doesn't belong to the current user"
  #   
  #   it "should render when the current member belongs to the current user"
  # end
  
  # describe "as anonymous" do
  #   it "should not render"
  # end
end

# -----------------------------------------------------------------------------
# New
# -----------------------------------------------------------------------------

describe MembersController, "GET /members/new" do
  def do_get
    get :new
  end
  
  before(:each) do
    Member.should_receive(:new).and_return(nil)
  end
  
  describe "as admin" do
    it "should render" do
      do_get
      response.should be_success
    end
  end
  
  # describe "as user" do
  #   it "should not render"
  # end
end

# -----------------------------------------------------------------------------
# Edit
# -----------------------------------------------------------------------------

describe MembersController, "GET /members/edit/:id" do
  def do_get
    get :edit, :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      @member = mock_model(Member)
      Member.should_receive(:find).with('1').and_return(@member)

      do_get
    end    

    it "should assign @member" do
      assigns[:member].should == @member
    end
    
    it "should render" do
      response.should be_success
    end
  end
  
  # describe "as user" do
  #   it "should not render"
  # end
end

# -----------------------------------------------------------------------------
# Create
# -----------------------------------------------------------------------------

describe MembersController, "POST /members" do
  def do_post
    post :create, :member => @plan
  end
  
  describe "as admin" do
    before(:each) do
      @mock = mock_model(Member, :to_param => '1', :save => true)
      @plan = Member.plan.stringify_keys!
      Member.should_receive(:new).with(@plan).and_return(@mock)
      do_post
    end
  
    it "should create a new member from params" do
      # All handled by before
    end
  
    describe "when successful" do
      it "should add a flash success message" do
        flash[:success].should == 'Member was successfully created.'
      end
    
      it "should redirect to the new member" do
        response.should redirect_to(member_url('1'))
      end
    end
  
    describe "when unsuccessful" do
      before(:each) do
        @mock = mock_model(Member, :save => false)
        Member.stub!(:new).and_return(@mock)
      end
    
      it "should render template :new" do
        do_post
        response.should render_template(:new)
      end
    end
  end
  
  # describe "as user" do
  #   it "should not render"
  # end
end

# -----------------------------------------------------------------------------
# Update
# -----------------------------------------------------------------------------

describe MembersController, "POST /members/:id" do
  def do_post
    post :update, :id => '1', :member => @plan
  end
  
  describe "as admin" do
    before(:each) do
      @mock = mock_model(Member, :to_param => '1', :update_attributes => true)
      @plan = Member.plan.stringify_keys!
      Member.stub!(:find).and_return(@mock)
    end
    
    it "should assign @member from params" do
      do_post
      assigns[:member].should == @mock
    end
    
    describe "when successful" do
      before(:each) do
        @mock.should_receive(:update_attributes).with(@plan).and_return(true)
        do_post
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
      before(:each) do
        @mock.should_receive(:update_attributes).and_return(false)
      end
      it "should render the edit form" do
        do_post
        response.should render_template(:edit)
      end
    end
  end
  
  # describe "as user" do
  #   it "should not do anything"
  # end
end

# -----------------------------------------------------------------------------
# Destroy
# -----------------------------------------------------------------------------

describe MembersController, "DELETE /members/:id" do
end