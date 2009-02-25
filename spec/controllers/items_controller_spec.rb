require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_item, :only => [:show, :edit, :update, :destroy]
def find_item
  @item ||= mock_model(Item, :to_param => '1')
  Item.should_receive(:find).with('1').and_return(@item)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /items/index
describe ItemsController, "#index" do
  def get_response()
    get :index
  end
  
  describe "as admin" do
    before(:each) do
      @item = mock_model(Item)
      Item.should_receive(:paginate).and_return(@item)
      get_response
    end
    
    it "should assign @items" do
      assigns[:items].should === @item
    end
    
    it "should render" do
      response.should render_template(:index)
      response.should be_success
    end
  end
  
  describe "as user" do
    it "should not render"
  end
end

# -----------------------------------------------------------------------------
# Show
# -----------------------------------------------------------------------------

# GET /items/show/:id
describe ItemsController, "#show" do
  def get_response
    get :show, :id => '1'
  end
  
  describe "as_admin" do
    before(:each) do
      find_item # Mocks Item.find once
      
      # Item receives a second call to :find to find all purchases by this item name
      @item.should_receive(:name).and_return('ItemName')
      Item.should_receive(:find).and_return('purchases')
      get_response
    end
    
    it "should assign @purchases" do
      assigns[:purchases].should == 'purchases'
    end
    
    it "should render" do
      response.should render_template(:show)
      response.should be_success
    end
  end
  
  describe "as user" do
    it "should not render"
  end
end