require 'spec_helper'

describe Members::RaidsController, "routing" do
  it { should route(:get, '/members/1/raids').to(:controller => 'members/raids', :action => :index, :member_id => '1') }
end

describe Members::RaidsController, "GET index" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    get :index, :member_id => @parent.id
  end

  subject { controller }

  it { should respond_with(:success) }
  it { should assign_to(:raids).with_kind_of(Array) }
  it { should render_template(:index) }
end
