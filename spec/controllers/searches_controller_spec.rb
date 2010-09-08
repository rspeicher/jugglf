require 'spec_helper'

describe SearchesController, "routing" do
  it { should route(:get, '/search').to(:controller => 'searches', :action => :show) }
end

describe SearchesController, "items" do
  before do
    @items = []
    2.times { @items << Factory(:item) }
  end

  subject { controller }

  context "with exact match" do
    before do
      get :show, :q => @items[0].name, :context => 'items'
    end

    it { should respond_with(:redirect) }
    it { should redirect_to(item_path(@items[0])) }
  end

  context "with multiple matches" do
    before do
      get :show, :q => 'Item', :context => 'items'
    end

    it { should respond_with(:success) }
    it { should render_template('items/index') }
    it { should assign_to(:items) }
  end
end

describe SearchesController, "members" do
  before do
    @members = []
    2.times { @members << Factory(:member) }
  end

  subject { controller }

  context "with exact match" do
    before do
      get :show, :q => @members[0].name, :context => 'members'
    end

    it { should respond_with(:redirect) }
    it { should redirect_to(member_path(@members[0])) }
  end

  context "with multiple matches" do
    before do
      get :show, :q => 'Member', :context => 'members'
    end

    it { should respond_with(:success) }
    it { should render_template('members/index') }
    it { should assign_to(:members) }
  end
end
