require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PunishmentsController do
  before(:each) do
    # before_filter :find_parent
    @punishment = mock_model(Punishment, :to_param => '1', :save => true)
    
    @member = mock_model(Member, :to_param => '1', :save => true)
    
    # @member.punishments
    @member.stub!(:punishments).and_return(@punishment)
    
    # @member.punishments.find(params[:id])
    # Called only for edit, update, destroy
    @member.punishments.stub!(:find).with('1').and_return(@punishment)
    @member.punishments.stub!(:create).and_return(@punishment)
      
    # Assigns @parent and @member inside the controller
    Member.should_receive(:find).with('1').and_return(@member)
  end

  # -----------------------------------------------------------------------------
  # New
  # -----------------------------------------------------------------------------

  # GET /members/:member_id/punishments/new
  describe PunishmentsController, "#new" do
    def do_get
      get :new, :member_id => '1'
    end
  
    before(:each) do
      Punishment.should_receive(:new).and_return(nil)
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

  # GET /members/:member_id/punishments/edit/:id
  describe PunishmentsController, "#edit" do
    def do_get
      get :edit, :member_id => '1', :id => '1'
    end
    
    describe "as admin" do
      before(:each) do
        do_get
      end    
  
      it "should assign @punishment" do
        assigns[:punishment].should == @punishment
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
  
  # POST /members/:member_id/punishments
  describe PunishmentsController, "#create" do
    def do_post
      post :create, :member_id => '1', :punishment => @plan
    end
    
    describe "as admin" do
      before(:each) do
        @mock = mock_model(Punishment, :to_param => '1', :create => nil, :save => true)
        @plan = Punishment.plan(:member => @member).stringify_keys!
        
        # @member.punishments.should_receive(:create).and_return(@mock)
        do_post
      end
          
      it "should create a new punishment from params" do
        # All handled by before
      end
          
      describe "when successful" do
        it "should add a flash success message" do
          flash[:success].should == 'Punishment was successfully created.'
        end
      
        it "should redirect to the new punishment" do
          response.should redirect_to(member_url('1'))
        end
      end
          
      describe "when unsuccessful" do
        before(:each) do
          # before_filter :find_parent
          # @punishment = mock_model(Punishment, :to_param => '1', :save => true)

          @member = mock_model(Member, :to_param => '1', :save => false)
          @mock = mock_model(Punishment, :to_param => '1', :create => nil, :save => false)

          # @member.punishments
          # @member.stub!(:punishments).and_return(@punishment)

          # @member.punishments.find(params[:id])
          # Called only for edit, update, destroy
          # @member.punishments.stub!(:find).with('1').and_return(@punishment)
          # @member.punishments.stub!(:create).and_return(nil)

          # Assigns @parent and @member inside the controller
          # Member.should_receive(:find).with('1').and_return(@member)
          
          @member.save.should be_false
          @mock.save.should be_false
        end
      
        it "should render template :new" do
          # do_post
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
  
  describe PunishmentsController, "POST /members/:member_id/punishments/:id" do
    def do_post
      post :update, :id => '1', :punishment => @plan
    end
    
    # describe "as admin" do
    #   before(:each) do
    #     @mock = mock_model(Punishment, :to_param => '1', :update_attributes => true)
    #     @plan = Punishment.plan.stringify_keys!
    #     Punishment.stub!(:find).and_return(@mock)
    #   end
    #   
    #   it "should assign @punishment from params" do
    #     do_post
    #     assigns[:punishment].should == @mock
    #   end
    #   
    #   describe "when successful" do
    #     before(:each) do
    #       @mock.should_receive(:update_attributes).with(@plan).and_return(true)
    #       do_post
    #     end
    #     
    #     it "should update attributes from params" do
    #       # All handled by before
    #     end
    #     
    #     it "should add a flash success message" do
    #       flash[:success].should == 'Punishment was successfully updated.'
    #     end
    #     
    #     it "should redirect back to the punishment" do
    #       response.should redirect_to(punishment_url('1'))
    #     end
    #   end
    #   
    #   describe "when unsuccessful" do
    #     before(:each) do
    #       @mock.should_receive(:update_attributes).and_return(false)
    #     end
    #     it "should render the edit form" do
    #       do_post
    #       response.should render_template(:edit)
    #     end
    #   end
    # end
    # 
    # # describe "as user" do
    # #   it "should not do anything"
    # # end
  end
  
  # -----------------------------------------------------------------------------
  # Destroy
  # -----------------------------------------------------------------------------
  
  describe PunishmentsController, "DELETE /members/:member_id/punishments/:id" do
  end
end