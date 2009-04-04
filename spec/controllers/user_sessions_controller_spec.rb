# require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# 
# def mock_user_session(extra_stubs = {})
#   # unless UserSession.find.nil?
#   #   puts "Getting existing member<br/>"
#   #   @user = UserSession.find.invision_user
#   # else
#   #   puts "Making user from scratch<br/>"
#   #   @user = UserSession.create(InvisionUser.make()).invision_user
#   # end
#   # 
#   # # @user = @current_user = UserSession.find.invision_user
#   # UserSession.stub!(:new).and_return(@user)
# end
# 
# # -----------------------------------------------------------------------------
# # New
# # -----------------------------------------------------------------------------
# 
# # GET /user_session/new
# describe UserSessionsController, "#new" do
#   def get_response
#     get :new
#   end
#   
#   describe "when logged in" do
#     it "should redirect somewhere else" do
#       login
#       UserSession.should_receive(:new).exactly(:once)
#       get_response
#       response.should redirect_to(root_path)
#     end
#   end
#   
#   describe "when logged out" do
#     it "should assign @user_session" do
#       # mock_user_session
#       get_response
#       response.should_not redirect_to(root_url)
#       assigns[:user_session].should_not be_nil
#     end
#   end
# end
# 
# # -----------------------------------------------------------------------------
# # Create
# # -----------------------------------------------------------------------------
# 
# # POST /user_session
# describe UserSessionsController, "#create" do
#   def get_response
#     post :create, :user_session => @params
#   end
#   
#   describe "when logged in" do
#     it "should redirect somewhere else" do
#       login
#       UserSessionsController.should_not_receive(:new)
#       get_response
#       response.should redirect_to(root_path)
#     end
#   end
#   
#   describe "when logged out" do
#     describe "when successful" do
#       before(:each) do
#         # mock_user_session
#         
#         # UserSession.should_receive(:new).at_least(:once).
#         #   and_return(UserSession.create(InvisionUser.make))
#         get_response
#       end
#       
#       # it "should assign @user_session" do
#       #   assigns[:user_session].should_not be_nil
#       # end
#     
#       it "should add a flash success message" do
#         flash[:success].should == 'Login successful!'
#       end
#       
#       it "should redirect back to default of members_url" do
#         response.should redirect_to(members_url)
#       end
#     end
#     
#     describe "when unsuccessful" do
#       it "should render action :new" do
#         # mock_user_session(:save => false)
#         get_response
#         response.should render_template(:new)
#       end
#     end
#   end
# end
# 
# # -----------------------------------------------------------------------------
# # Destroy
# # -----------------------------------------------------------------------------
# 
# # DELETE /user_session
# describe UserSessionsController, "#destroy" do
#   def get_response
#     delete :destroy
#   end
#   
#   describe "when logged in" do
#     before(:each) do
#       login
#       @current_user.should_receive(:destroy)
#       get_response
#     end
#     
#     it "should destroy the current session" do
#     end
#     
#     it "should add a flash success message" do
#       flash[:success].should == 'Logout successful.'
#     end
#     
#     it "should redirect to root_url" do
#       response.should redirect_to(root_url)
#     end
#   end
#   
#   describe "when logged out" do
#     it "should redirect to new_user_session_url" do
#       get_response
#       response.should redirect_to(new_user_session_url)
#     end
#   end
# end