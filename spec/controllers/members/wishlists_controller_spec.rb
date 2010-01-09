require 'spec_helper'

module MembersWishlistsHelperMethods
  def mock_find
    # This is a namespaced controller, so it always has a parent
    @parent ||= @member ||= Factory(:member)
    Member.should_receive(:find).with(@parent.to_param).exactly(:once).and_return(@member)
    
    Loot.stub!(:find).and_return([])
  end
  
  def params(extras = {})
    {:member_id => @parent.to_param}.merge!(extras)
  end
end

describe Members::WishlistsController, "#index" do
  include MembersWishlistsHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    get :index, params
  end
  
  it { should assign_to(:wishlists) }
  it { should respond_with(:success) }
  it { should render_template(:index) }
end