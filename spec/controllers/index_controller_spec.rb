require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /index
describe IndexController do
  def get_response
    get :index
  end
  
  it "should render" do
    get_response
    response.should render_template(:index)
  end
end
