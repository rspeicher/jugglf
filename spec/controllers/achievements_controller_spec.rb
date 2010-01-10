require 'spec_helper'

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /achievements
describe AchievementsController, "#index" do
  def get_response
    get :index
  end
  
  before(:each) do
    Achievement.should_receive(:find).and_return(['achievements'])
    Member.should_receive(:active).and_return(mock_model(Member, :find => ['members']))
  end
  
  it "should render" do
    get_response
    response.should render_template(:index)
  end
end