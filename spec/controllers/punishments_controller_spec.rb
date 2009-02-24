require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PunishmentsController do
  before(:each) do
    # before_filter :find_parent
    @punishment = mock_model(Punishment)
    @member = mock_model(Member, 
      :punishments => mock_model(Punishment, :find => @punishment))
    Member.should_receive(:find).with('1').and_return(@member)
  end

  # -----------------------------------------------------------------------------
  # New
  # -----------------------------------------------------------------------------

  describe PunishmentsController, "GET /members/:member_id/punishments/new" do
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

  describe PunishmentsController, "GET /members/:member_id/punishments/edit/:id" do
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
  
  # describe PunishmentsController, "POST /members/:member_id/punishments" do
  #   def do_post
  #     post :create, :punishment => @plan
  #   end
  #   
  #   describe "as admin" do
  #     before(:each) do
  #       @mock = mock_model(Punishment, :to_param => '1', :save => true)
  #       @plan = Punishment.plan.stringify_keys!
  #       Punishment.should_receive(:new).with(@plan).and_return(@mock)
  #       do_post
  #     end
  #   
  #     it "should create a new punishment from params" do
  #       # All handled by before
  #     end
  #   
  #     describe "when successful" do
  #       it "should add a flash success message" do
  #         flash[:success].should == 'Punishment was successfully created.'
  #       end
  #     
  #       it "should redirect to the new punishment" do
  #         response.should redirect_to(punishment_url('1'))
  #       end
  #     end
  #   
  #     describe "when unsuccessful" do
  #       before(:each) do
  #         @mock = mock_model(Punishment, :save => false)
  #         Punishment.stub!(:new).and_return(@mock)
  #       end
  #     
  #       it "should render template :new" do
  #         do_post
  #         response.should render_template(:new)
  #       end
  #     end
  #   end
  #   
  #   # describe "as user" do
  #   #   it "should not render"
  #   # end
  # end
  # 
  # # -----------------------------------------------------------------------------
  # # Update
  # # -----------------------------------------------------------------------------
  # 
  # describe PunishmentsController, "POST /members/:member_id/punishments/:id" do
  #   def do_post
  #     post :update, :id => '1', :punishment => @plan
  #   end
  #   
  #   describe "as admin" do
  #     before(:each) do
  #       @mock = mock_model(Punishment, :to_param => '1', :update_attributes => true)
  #       @plan = Punishment.plan.stringify_keys!
  #       Punishment.stub!(:find).and_return(@mock)
  #     end
  #     
  #     it "should assign @punishment from params" do
  #       do_post
  #       assigns[:punishment].should == @mock
  #     end
  #     
  #     describe "when successful" do
  #       before(:each) do
  #         @mock.should_receive(:update_attributes).with(@plan).and_return(true)
  #         do_post
  #       end
  #       
  #       it "should update attributes from params" do
  #         # All handled by before
  #       end
  #       
  #       it "should add a flash success message" do
  #         flash[:success].should == 'Punishment was successfully updated.'
  #       end
  #       
  #       it "should redirect back to the punishment" do
  #         response.should redirect_to(punishment_url('1'))
  #       end
  #     end
  #     
  #     describe "when unsuccessful" do
  #       before(:each) do
  #         @mock.should_receive(:update_attributes).and_return(false)
  #       end
  #       it "should render the edit form" do
  #         do_post
  #         response.should render_template(:edit)
  #       end
  #     end
  #   end
  #   
  #   # describe "as user" do
  #   #   it "should not do anything"
  #   # end
  # end
  # 
  # # -----------------------------------------------------------------------------
  # # Destroy
  # # -----------------------------------------------------------------------------
  # 
  # describe PunishmentsController, "DELETE /members/:member_id/punishments/:id" do
  # end
end