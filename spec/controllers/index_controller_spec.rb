require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# -----------------------------------------------------------------------------
# Index
# -----------------------------------------------------------------------------

# GET /index
describe IndexController do
  def get_response
    get :index
  end
  
  before(:each) do
    IndexStat.stub!(:attendance_average).and_return(nil)
    IndexStat.stub!(:loot_factor_average).and_return(nil)
    IndexStat.stub!(:common_items).and_return(nil)
    IndexStat.stub!(:common_tokens).and_return(nil)
    IndexStat.stub!(:most_requested).and_return(nil)
    IndexStat.stub!(:loots_per_raid).and_return(nil)
    IndexStat.stub!(:oldest_members).and_return(nil)
    IndexStat.stub!(:least_recruitable).and_return(nil)
    IndexStat.stub!(:highest_turnover).and_return(nil)
  end
  
  it "should render" do
    get_response
    response.should render_template(:index)
  end
end
