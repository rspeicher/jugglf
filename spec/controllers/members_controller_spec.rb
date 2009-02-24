require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

describe MembersController, "GET /members/index" do
  before(:each) do
    Member.should_receive(:find_all_by_active).and_return(nil)
  end
  
  it "should render" do
    get :index
    response.should be_success
  end
  
  describe ".lua" do
    it "should render" do
      get :index, :format => 'lua'
      response.should be_success      
    end
  end
end

# -----------------------------------------------------------------------------
# Show
# -----------------------------------------------------------------------------

describe MembersController, "GET /members/:id" do
  def do_get
    get :show, :id => '1'
  end
  
  describe "when admin" do
    describe "with valid parameter" do
      before(:each) do
        @member = mock_model(Member, 
          :punishments => mock_model(Punishment, :find_all_active => 'punishments')
        )
        Member.should_receive(:find).with('1').and_return(@member)

        Raid.should_receive(:count).and_return(0)
        Raid.should_receive(:paginate).and_return('raids')

        do_get
      end    

      it "should render" do
        response.should be_success
      end

      it "should assign @member" do
        assigns[:member].should == @member
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
    end
  end
  
  # describe "when member" do
  #   it "should not render if the member doesn't belong to the current user"
  #   
  #   it "should render when the current member belongs to the current user"
  # end
  
  # describe "when anonymous" do
  #   it "should not render"
  # end
  
  describe "with invalid parameter" do
  end
end

# -----------------------------------------------------------------------------
# New
# -----------------------------------------------------------------------------

describe MembersController, "GET /members/new" do
  before(:each) do
    Member.should_receive(:new).and_return(nil)
  end
  
  describe "when admin" do
    it "should render" do
      get :new
      response.should be_success
    end
  end
  
  # describe "when not admin" do
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
  
  describe "when admin" do
    describe "with valid parameter" do
      before(:each) do
        @member = mock_model(Member)
        Member.should_receive(:find).with('1').and_return(@member)

        do_get
      end    
      
      it "should render" do
        response.should be_success
      end
      
      it "should assign @member" do
        assigns[:member].should == @member
      end
    end
    
    describe "with invalid parameter" do
      it "should raise an error" do
        lambda { do_get }.should raise_error
      end
    end
  end
  
  # describe "when not admin" do
  #   it "should not render"
  # end
end

# -----------------------------------------------------------------------------
# Create
# -----------------------------------------------------------------------------

describe MembersController, "POST /members" do
  before(:each) do
    @mock = mock_model(Member, :to_param => '1', :save => true)
    @plan = Member.plan.stringify_keys!
  end
  
  def do_post
    post :create, :member => @plan
  end
  
  it "should create a new member from params" do
    Member.should_receive(:new).with(@plan).and_return(@mock)
    do_post
  end
  
  describe "when successful" do
    before(:each) do
      Member.should_receive(:new).with(@plan).and_return(@mock)
    end
    
    it "should add a flash success message" do
      do_post
      flash[:success].should == 'Member was successfully created.'
    end
    
    it "should redirect to the new member" do
      do_post
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

# -----------------------------------------------------------------------------
# Update
# -----------------------------------------------------------------------------

describe MembersController, "POST /members/:id" do
  before(:each) do
    @mock = mock_model(Member, :to_param => '1', :update_attributes => true)
    @plan = Member.plan.stringify_keys!
  end
  
  def do_post
    post :update, :id => '1', :member => @plan
  end
  
  describe "when admin" do
    before(:each) do
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
  
  # describe "when not admin" do
  #   it "should not do anything"
  # end
end

# -----------------------------------------------------------------------------
# Destroy
# -----------------------------------------------------------------------------

describe MembersController, "DELETE /members/:id" do
end