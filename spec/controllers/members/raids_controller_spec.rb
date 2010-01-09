require 'spec_helper'

module MembersRaidsHelperMethods
  def mock_find
    # This is a namespaced controller, so it always has a parent
    # We stub :loots to LiveLoot so that @parent.loots.find works as expected
    @parent ||= @member ||= Factory(:member)
    Member.should_receive(:find).with(anything()).exactly(:once).and_return(@member)
  end
  
  def params(extras = {})
    {:member_id => @parent.id}.merge!(extras)
  end
end

describe Members::RaidsController, "#index" do
  include MembersRaidsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    Raid.should_receive(:paginate).with(anything()).and_return([])
    get :index, params
  end
  
  it { should assign_to(:raids) }
  it { should respond_with(:success) }
  it { should render_template(:index) }
end