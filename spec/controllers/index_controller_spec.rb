require 'spec_helper'

describe IndexController, "routing" do
  it { should route(:get, '/').to(:controller => :index, :action => :index) }
end

describe IndexController, "GET index" do
  before(:each) do
    IndexStat.stub!(:attendance_average).and_return([])
    IndexStat.stub!(:loot_factor_average).and_return([])
    IndexStat.stub!(:common_items).and_return([])
    IndexStat.stub!(:common_tokens).and_return([])
    IndexStat.stub!(:most_requested).and_return([])
    IndexStat.stub!(:loots_per_raid).and_return([])
    IndexStat.stub!(:oldest_members).and_return([])
    IndexStat.stub!(:least_recruitable).and_return([])
    IndexStat.stub!(:highest_turnover).and_return([])
    IndexStat.stub!(:fragment_progress).and_return([])
    get :index
  end

  it { should assign_to(:count_guild).with_kind_of(Integer) }
  it { should assign_to(:counts) }
  it { should assign_to(:attendance_guild) }
  it { should assign_to(:attendance) }
  it { should assign_to(:lootfactor_guild) }
  it { should assign_to(:lootfactor) }
  it { should assign_to(:stat_groups) }
  it { should render_template(:index) }
  it { should respond_with(:success) }
end