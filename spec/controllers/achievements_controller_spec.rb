require 'spec_helper'

describe MembersController, "routing" do
  it { should route(:get, '/achievements').to(:controller => :achievements, :action => :index) }
end

describe AchievementsController, "GET index" do
  before(:each) do
    get :index
  end

  it { should respond_with(:success) }
  it { should assign_to(:achievements).with_kind_of(Array) }
  it { should assign_to(:members).with_kind_of(Array) }
  it { should render_template(:index) }
end