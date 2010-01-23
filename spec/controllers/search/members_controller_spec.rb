require 'spec_helper'

describe Search::MembersController, "routing" do
  it { should route(:get, '/search/members'     ).to(:controller => 'search/members', :action => :index) }
  it { should route(:get, '/search/members.json').to(:controller => 'search/members', :action => :index, :format => 'json') }
end

describe Search::MembersController, "GET index" do
  before(:each) do
    @members = []
    2.times { @members << Factory(:member) }
  end

  context ".html" do
    context "with exact match" do
      before(:each) do
        get :index, :q => @members[0].name
      end

      it { should redirect_to(member_path(@members[0])) }
    end

    context "with multiple matches" do
      before(:each) do
        get :index, :q => 'Member'
      end

      it { should respond_with(:success) }
      it { should render_template('members/index') }
      it { should assign_to(:members).with_kind_of(Array) }
    end
  end

  context ".js" do
    before(:each) do
      get :index, :q => 'Member', :format => 'js'
    end

    it { should respond_with(:success) }
    it "should not include certain fields" do
      response.should_not have_text('created_at')
      response.should_not have_text('updated_at')
    end
  end

  context ".json" do
    before(:each) do
      get :index, :q => 'Member', :format => 'json'
    end

    it { should respond_with(:success) }
    it "should not include certain fields" do
      response.should_not have_text('created_at')
      response.should_not have_text('updated_at')
    end
  end

  context ".xml" do
    before(:each) do
      get :index, :q => 'Member', :format => 'xml'
    end

    it { should respond_with(:success) }
    it "should not include certain fields" do
      response.should_not have_text('created_at')
      response.should_not have_text('updated_at')
    end
  end
end