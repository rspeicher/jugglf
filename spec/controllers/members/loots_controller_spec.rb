require 'spec_helper'

module MembersLootsHelperMethods
  def mock_find
    # This is a namespaced controller, so it always has a parent
    # We stub :loots to Loot so that @parent.loots.paginate works as expected
    @parent ||= @member ||= mock_model(Member, :loots => Loot)
    Member.should_receive(:find).with(anything()).exactly(:once).and_return(@member)
    
    @loot ||= mock_model(Loot)
    Loot.should_receive(:paginate).with(anything()).exactly(:once).and_return(@loot)
  end
  
  def params(extras = {})
    {:member_id => @parent.id}.merge!(extras)
  end
end

describe Members::LootsController, "#index" do
  include MembersLootsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    get :index, params
  end
  
  it { should assign_to(:loots) }
  it { should respond_with(:success) }
  it { should render_template(:index) }
end