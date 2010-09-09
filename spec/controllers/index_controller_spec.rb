require 'spec_helper'

describe IndexController, "routing" do
  it { should route(:get, '/').to(:controller => :index, :action => :index) }
end

describe IndexController, "GET index" do
  before do
    (IndexStat.public_methods - Class.instance_methods).each do |method|
      IndexStat.stubs(method.to_sym).returns([])
    end

    get :index
  end

  it { should assign_to(:count_guild) }
  it { should assign_to(:counts) }
  it { should assign_to(:attendance_guild) }
  it { should assign_to(:attendance) }
  it { should assign_to(:lootfactor_guild) }
  it { should assign_to(:lootfactor) }
  it { should assign_to(:stat_groups) }
  it { should render_template(:index) }
  it { should respond_with(:success) }
end
