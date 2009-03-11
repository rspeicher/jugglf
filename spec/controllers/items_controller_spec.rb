require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_item, :only => [:show, :edit, :update, :destroy]
def find_item
  @item ||= mock_model(Item, :to_param => '1')
  Item.should_receive(:find).with('1').and_return(@item)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /items
describe ItemsController, "#index" do
  def get_response
    get :index
  end
  
  it "should render" do
    Item.should_receive(:paginate).and_return('Item')
    get_response
    response.should render_template(:index)
  end
end

# -----------------------------------------------------------------------------
# Show
# -----------------------------------------------------------------------------

# # GET /items/show/:id
describe ItemsController, "#show" do
  def get_response
    get :show, :id => '1'
  end
  
  before(:each) do
    login({}, :is_admin? => true)
    
    # Set up @item before find_item so we get the stubs we want
    @loot        = mock_model(Loot)
    @wishlist    = mock_model(Wishlist)
    @item        = mock_model(Item, :to_param => '1', :loots => @loot, 
      :wishlists => @wishlist)
    find_item
    
    @loot.should_receive(:find).and_return([@loot])
    @wishlist.should_receive(:find).and_return([@wishlist])
    
    get_response
  end
  
  it "should assign @loots" do
    assigns[:loots].should == [@loot]
  end
  
  it "should assign @wishlists" do
    assigns[:wishlists].should == [@wishlist]
  end
  
  it "should render" do
    response.should render_template(:show)
    response.should be_success
  end
end