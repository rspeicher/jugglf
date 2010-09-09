require 'spec_helper'

describe Members::LootsController, "routing" do
  it { should route(:get, '/members/1/loots').to(:controller => 'members/loots', :action => :index, :member_id => '1') }
end

describe Members::LootsController, "GET index" do
  before do
    @parent = Factory(:member)
    get :index, :member_id => @parent
  end

  it { should respond_with(:success) }
  it { should assign_to(:loots).with_kind_of(Array) }
  it { should render_template(:index) }
end
