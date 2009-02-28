require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# before_filter :find_loot, :only => [:show, :edit, :update, :destroy]
def find_loot
  @loot ||= mock_model(Loot, :to_param => '1')
  Loot.should_receive(:find).with('1').and_return(@loot)
end

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /loots/index
describe LootsController, "#index" do
  def get_response()
    get :index
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      @loot = mock_model(Loot)
      Loot.should_receive(:paginate).and_return(@loot)
      get_response
    end
    
    it "should assign @loots" do
      assigns[:loots].should === @loot
    end
    
    it "should render" do
      response.should render_template(:index)
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
end