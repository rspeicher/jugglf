require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_parent
def find_parent
  @parent ||= @member ||= mock_model(Member, :to_param => '1', 
    :punishments => mock_model(Punishment))
  Member.should_receive(:find).with('1').and_return(@member)
end

# before_filter :find_punishment, :only => [:edit, :update, :destroy]
def find_punishment
  @punishment ||= @member.punishments
  @member.punishments.should_receive(:find).with('1').and_return(@punishment)
end

# -----------------------------------------------------------------------------
# New
# -----------------------------------------------------------------------------

# GET /punishments/new
describe PunishmentsController, "#new" do
end

# GET /members/:member_id/punishments/new
describe PunishmentsController, "#new" do
  def get_response
    get :new, :member_id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      find_parent()
      @punishment = mock_model(Punishment)
      Punishment.should_receive(:new).and_return(@punishment)
      get_response
    end
    
    it "should assign @punishment" do
      assigns[:punishment].should === @punishment
    end
  
    it "should render" do
      response.should render_template(:new)
      response.should be_success
    end
  end
  
  describe "as user" do
    it "should not render"
  end
end

# -----------------------------------------------------------------------------
# Edit
# -----------------------------------------------------------------------------

# GET /punishments/:id/edit
describe PunishmentsController, "#edit" do
end

# GET /members/:member_id/punishments/:id/edit
describe PunishmentsController, "#edit" do
  def get_response
    get :edit, :member_id => '1', :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      find_parent
      find_punishment
      get_response
    end
    
    it "should assign @punishment" do
      assigns[:punishment].should === @punishment
    end
    
    it "should render" do
      response.should render_template(:edit)
      response.should be_success
    end
  end
  
  describe "as user" do
    it "should not render"
  end
end

# -----------------------------------------------------------------------------
# Create
# -----------------------------------------------------------------------------

# POST /punishments
describe PunishmentsController, "#create" do
end

# POST /members/:member_id/punishments
describe PunishmentsController, "#create" do
  def get_response
    post :create, :member_id => '1', :punishment => @params
  end
  
  describe "as admin" do
    before(:each) do
      find_parent
      @params = Punishment.plan(:member => @parent).stringify_keys!
      @punishment = mock_model(Punishment)
      @member.punishments.should_receive(:create).with(@params).and_return(@punishment)
    end
    
    describe "when successful" do
      before(:each) do
        @punishment.should_receive(:save).and_return(true)
        get_response
      end
      
      it "should create a new punishment from params" do
        assigns[:punishment].should === @punishment
      end
      
      it "should add a flash success message" do
        flash[:success].should == 'Punishment was successfully created.'
      end
      
      it "should redirect to the parent member" do
        response.should redirect_to(member_url('1'))
      end
    end
    
    describe "when unsuccessful" do
      it "should render template :new" do
        @punishment.should_receive(:save).and_return(false)
        get_response
        response.should render_template(:new)
      end
    end
  end
  
  describe "as user" do
    it "should not render"
  end
end

# -----------------------------------------------------------------------------
# Update
# -----------------------------------------------------------------------------

# PUT /punishments/:id
describe PunishmentsController, "#update" do
end

# PUT /members/:member_id/punishments/:id
describe PunishmentsController, "#update" do
  def get_response
    put :update, :member_id => '1', :id => '1', :punishment => @params
  end
  
  describe "as admin" do
    before(:each) do
      find_parent
      find_punishment
      @params = Punishment.plan(:member => @parent).stringify_keys!
    end
    
    describe "when successful" do
      before(:each) do
        @punishment.should_receive(:update_attributes).with(@params).and_return(true)
      end
      
      it "should add a flash success message" do
        get_response
        flash[:success].should == 'Punishment was successfully updated.'
      end
      
      it "should redirect to the parent member" do
        get_response
        response.should redirect_to(member_url('1'))
      end
    end
    
    describe "when unsuccessful" do
      it "should render template :edit" do
        @punishment.should_receive(:update_attributes).with(@params).and_return(false)
        get_response
        response.should render_template(:edit)
      end
    end
  end
  
  describe "as user" do
    it "should not render"
  end
end

# -----------------------------------------------------------------------------
# Destroy
# -----------------------------------------------------------------------------

# DELETE /punishments/:id
describe PunishmentsController, "#destroy" do
end

# DELETE /members/:member_id/punishments/:id
describe PunishmentsController, "#destroy" do
  def get_response
    delete :destroy, :member_id => '1', :id => '1'
  end
  
  describe "as admin" do
    before(:each) do
      find_parent
      find_punishment
      @punishment.should_receive(:destroy)
      get_response
    end
    
    it "should call destroy on the found punishment" do
      # All handled by before
    end
    
    it "should redirect to the parent member" do
      response.should redirect_to(member_url('1'))
    end
  end
  
  describe "as user" do
    it "should not render"
  end
end