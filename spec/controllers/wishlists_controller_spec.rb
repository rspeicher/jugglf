require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_parent
def find_wishlist_parent
  @parent ||= @member ||= Member.make(:id => '1', :name => 'MemberName')
  @parent.wishlists.make
  Member.should_receive(:find).with(anything(), anything()).and_return(@parent)
end

# before_filter :find_wishlist, :only => [:edit, :update, :destroy]
def find_wishlist
  @wishlist ||= @parent.wishlists[0]
  @parent.wishlists.should_receive(:find).and_return(@wishlist)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /wishlists
describe WishlistsController, "#index" do
  def get_response(params = {})
    get :index, params
  end
  
  describe "as admin" do
    before(:each) do
      login(:admin)
      @zone = mock_model(Zone, :name => 'Zone')
      LootTable.should_receive(:find_all_by_object_type).with('Zone', anything()).
        and_return([@zone])
    end
    
    it "should assign @root" do
      get_response
      assigns[:root].should == [@zone]
    end
    
    it "should assign @zone" do
      get_response
      assigns[:zone].should == nil
      assigns[:boss].should == nil
    end
    
    it "should assign empty @items" do
      get_response
      assigns[:items].should == []
    end
    
    it "should render" do
      get_response
      response.should render_template(:index)
    end
    
    describe "with boss parameter" do
      before(:each) do
        @boss = mock_model(Boss, :parent => 'ParentZone')
        @item = mock_model(LootTable, :parent => @boss)
        LootTable.should_receive(:find).and_return([@item])
        get_response(:boss => '1')
      end
      
      it "should assign @items" do
        assigns[:items].should == [@item]
      end
      
      it "should re-assign @zone" do
        assigns[:zone].should == 'ParentZone'
      end
    end
    
    describe "with boss parameter for which there are no items" do
        before(:each) do
          @boss = mock_model(Boss, :parent => 'ParentZone')
          LootTable.should_receive(:find).with(:all, anything()).and_return([]) # Find items
          LootTable.should_receive(:find).with('1').and_return(@boss)           # No items, just find the boss
          get_response(:boss => '1')
        end

        it "should assign @boss" do
          assigns[:boss].should == @boss
        end

        it "should re-assign @zone" do
          assigns[:zone].should == 'ParentZone'
        end
      end
  end
  
  describe "as user" do
    it "should redirect to root_url" do
      login
      get_response
      response.should redirect_to(root_url)
    end
  end
  
  describe "as anonymous" do
    it "should redirect to login" do
      get_response
      response.should redirect_to(new_user_session_url)
    end
  end
end

# -----------------------------------------------------------------------------
# New
# -----------------------------------------------------------------------------

# GET /wishlists/new
# describe WishlistsController, "#new" do
#   def get_response
#     get :new, :member_id => '1'
#   end
#   
#   describe "as user" do
#     before(:each) do
#       find_wishlist_parent
#       login(:user, :member => @parent)
#       @new_wishlist = Wishlist.make_unsaved(:item => Item.make(:name => 'My Item'))
#       @parent.wishlists.should_receive(:new).and_return(@new_wishlist)
#       get_response
#     end
#     
#     it "should assign @wishlist" do
#       assigns[:wishlist].should == @new_wishlist
#     end
#     
#     it "should render" do
#       response.should render_template(:new)
#     end
#   end
#   
#   describe "as anonymous" do
#     it "should redirect to login" do
#       get_response
#       response.should redirect_to(new_user_session_url)
#     end
#   end
# end

# -----------------------------------------------------------------------------
# Edit
# -----------------------------------------------------------------------------

# # GET /wishlists/:id
# describe WishlistsController, "#edit" do
#   def get_response(type = :normal)
#     if type == :normal
#       get :edit, :member_id => '1', :id => '1'
#     elsif type == :xhr
#       xhr :get, :edit, :member_id => '1', :id => '1'
#     end
#   end
#   
#   describe "as user" do
#     before(:each) do
#       find_wishlist_parent
#       login(:user, :member => @parent)
#       find_wishlist
#     end
#     
#     # describe "wanting HTML" do
#     #   before(:each) do
#     #     get_response
#     #   end
#     # 
#     #   it "should assign @wishlist" do
#     #     assigns[:wishlist].should == @wishlist
#     #   end
#     # 
#     #   it "should render" do
#     #     response.should render_template(:edit)
#     #   end
#     # end
#     
#     describe "wanting JS" do
#       it "should render" do
#         get_response(:xhr)
#         response.should render_template(:edit_inline)
#       end
#     end
#   end
#   
#   describe "as anonymous" do
#     it "should redirect to login" do
#       get_response
#       response.should redirect_to(new_user_session_url)
#     end
#   end
# end
# 
# # -----------------------------------------------------------------------------
# # Create
# # -----------------------------------------------------------------------------
# 
# # POST /members
# describe WishlistsController, "#create" do
#   def get_response(type = :normal)
#     if type == :normal
#       post :create, :member_id => '1', :wishlist => @params
#     elsif type == :xhr
#       xhr :post, :create, :member_id => '1', :wishlist => @params
#     end
#   end
#   
#   describe "as user" do
#     describe "when successful" do
#       before(:each) do
#         find_wishlist_parent
#         login(:user, :member => @parent)
#         @wishlist = mock_model(Wishlist, :to_param => '1', :save => true)
#         @params = Wishlist.plan(:member => @parent).stringify_keys!
#         @parent.wishlists.should_receive(:new).with(@params).and_return(@wishlist)
#       end
#       
#       describe "wanting HTML" do
#         before(:each) do
#           get_response
#         end
#         
#         it "should create a new wishlist from params" do
#           assigns[:wishlist].should == @wishlist
#         end
#       
#         it "should add a flash success message" do
#           flash[:success].should == 'Wishlist entry was successfully created.'
#         end
# 
#         it "should redirect to the new wishlist" do
#           response.should redirect_to(wishlists_url)
#         end
#       end
#       
#       describe "wanting JS" do
#         it "should be successful" do
#           get_response(:xhr)
#           response.should render_template("wishlists/_create")
#         end
#       end
#     end
# 
#     describe "when unsuccessful" do
#       before(:each) do
#         find_wishlist_parent
#         login(:user, :member => @parent)
#         @wishlist = mock_model(Wishlist, :save => false)
#         @params = Wishlist.plan(:member => @parent).stringify_keys!
#         @parent.wishlists.stub!(:new).and_return(@wishlist)
#       end
#       
#       # describe "wanting HTML" do
#       #   it "should render template :new" do
#       #     get_response
#       #     response.should render_template(:new)
#       #   end
#       # end
#       
#       describe "wanting JS" do
#         it "should render template :create_failure" do
#           get_response(:xhr)
#           response.should render_template("wishlists/_create")
#         end
#       end
#     end
#   end
#   
#   describe "as anonymous" do
#     it "should redirect to login" do
#       get_response
#       response.should redirect_to(new_user_session_url)
#     end
#   end
# end
# 
# # -----------------------------------------------------------------------------
# # Update
# # -----------------------------------------------------------------------------
# 
# # PUT /wishlists/:id
# describe WishlistsController, "#update" do
#   def get_response(type = :normal)
#     if type == :normal
#       put :update, :member_id => '1', :id => '1', :wishlist => @params
#     elsif type == :xhr
#       xhr :put, :update, :member_id => '1', :id => '1', :wishlist => @params
#     end
#   end
#   
#   describe "as user" do
#     before(:each) do
#       find_wishlist_parent
#       find_wishlist
#       @params = Wishlist.plan(:member => @parent).stringify_keys!
#     end
#     
#     describe "when successful" do
#       before(:each) do
#         login(:user, :member => @parent)
#         @wishlist.should_receive(:update_attributes).with(@params).and_return(true)
#       end
#       
#       describe "wanting HTML" do
#         before(:each) do
#           get_response
#         end
#         
#         it "should add a flash success message" do
#           flash[:success].should == 'Wishlist entry was successfully updated.'
#         end
#         
#         it "should redirect to wishlists_path" do
#           response.should redirect_to(wishlists_path)
#         end
#       end
#       
#       describe "wanting JS" do
#         it "should render :update" do
#           get_response(:xhr)
#           response.should render_template("wishlists/_update")
#         end
#       end
#     end
#     
#     describe "when unsuccessful" do
#       before(:each) do
#         login(:user, :member => @parent)
#         @wishlist.should_receive(:update_attributes).with(@params).and_return(false)
#       end
#       
#       # describe "wanting HTML" do
#       #   it "should render :edit" do
#       #     get_response
#       #     response.should render_template(:edit)
#       #   end
#       # end
#       
#       describe "wanting JS" do
#         it "should render :update" do
#           get_response(:xhr)
#           response.should render_template("wishlists/_update")
#         end
#       end
#     end
#   end
#   
#   describe "as anonymous" do
#     it "should redirect to login" do
#       get_response
#       response.should redirect_to(new_user_session_url)
#     end
#   end
# end
# 
# # -----------------------------------------------------------------------------
# # Destroy
# # -----------------------------------------------------------------------------
# 
# # DELETE /wishlists/:id
# describe WishlistsController, "#destroy" do
#   def get_response(type = :normal)
#     if type == :normal
#       delete :destroy, :member_id => '1', :id => '1'
#     elsif type == :xhr
#       xhr :delete, :destroy, :member_id => '1', :id => '1'
#     end
#   end
#   
#   describe "as user" do
#     before(:each) do
#       find_wishlist_parent
#       login(:user, :member => @parent)
#       find_wishlist
#       @wishlist.should_receive(:destroy).and_return(nil)
#     end
#     
#     describe "for HTML" do
#       before(:each) do
#         get_response
#       end
#     
#       it "should add a flash success message" do
#         flash[:success].should == 'Wishlist entry was successfully deleted.'
#       end
#     
#       it "should redirect to #index" do
#         response.should redirect_to(wishlists_path)
#       end
#     end
#     
#     describe "for Javascript" do
#       it "should be successful" do
#         get_response(:xhr)
#         response.should be_success
#       end
#     end
#   end
#   
#   describe "as anonymous" do
#     it "should redirect to login" do
#       get_response
#       response.should redirect_to(new_user_session_url)
#     end
#   end
# end

# -----------------------------------------------------------------------------
# Misc
# -----------------------------------------------------------------------------

# Make sure a member can't modify another member's wishlist entries
# TODO: Move to Members::WishlistsController spec
# describe WishlistsController, "forged posts" do
#   def get_response()
#     xhr :delete, :destroy, :member_id => '999', :id => '1'
#   end
#   
#   before(:each) do
#     Member.destroy_all
#     
#     # Create a member with ID 999
#     @not_me = Member.make(:id => '999', :name => 'Sebudai')
#     
#     # Create a member with ID 1
#     @me = Member.make(:id => '1', :name => 'Tsigo')
#     
#     # Create a wishlist entry for Sebudai, ID 1
#     @not_me.wishlists.make(:id => '1', :item => Item.make(:name => 'Sebudai\'s Item'))
#   end
#   
#   it "should set up the environment" do
#     @not_me.id.should == 999
#     @me.id.should == 1
#     
#     Wishlist.count.should == 1
#     @me.wishlists.count.should == 0
#     @not_me.wishlists.count.should == 1
#   end
#   
#   it "should delete the record when I am an admin" do
#     login(:admin, :member => @me)
#     lambda { get_response }.should change(Wishlist, :count).by(-1)
#   end
#   
#   it "should not delete a wishlist entry that isn't mine" do
#     login(:user, :member => @me)
#     lambda { get_response }.should raise_error(ActiveRecord::RecordNotFound)
#   end
#   
#   it "should delete a wishlist entry that is mine" do
#     login(:user, :member => @not_me)
#     lambda { get_response }.should change(Wishlist, :count).by(-1)
#   end
#   
#   it "should require_admin when I have no member associated" do
#     login(:user, :member => nil)
#     get_response
#     response.should redirect_to(root_url)
#   end
# end