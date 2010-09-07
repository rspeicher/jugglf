require 'spec_helper'

describe SearchesController, "routing" do
  it { should route(:get, '/search').to(:controller => 'searches', :action => :show) }
end

describe SearchesController, "given invalid context" do
  before do
    @member = Factory(:member, :name => 'ItemSearch')
    get :show, :q => 'Item'
  end

  subject { controller }

  it { should respond_with(:redirect) }
  it { should redirect_to(member_path(@member)) }
end

describe SearchesController, "items" do
  before do
    @items = []
    2.times { @items << Factory(:item) }
  end

  subject { controller }

  context ".html" do
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
      it { should assign_to(:items).with_kind_of(Array) }
    end

    context "using Wowhead-like matching" do
      before do
        @item = Factory(:item, :name => "Conqueror's Mark of Sanctification")
        get :show, :q => 'conq sanc', :context => 'items'
      end

      it { should redirect_to(item_path(@item)) }
    end
  end

  context ".js" do
    before do
      get :show, :q => 'Item', :format => 'js', :context => 'items'
    end

    it { should respond_with(:success) }

    # TODO: Replace with feature
    it "should not include certain fields" do
      # response.should_not have_text('created_at')
      # response.should_not have_text('updated_at')
    end
  end

  context ".json" do
    before do
      get :show, :q => 'Item', :format => 'json', :context => 'items'
    end

    it { should respond_with(:success) }

    # TODO: Replace with feature
    it "should not include certain fields" do
      # response.should_not have_text('created_at')
      # response.should_not have_text('updated_at')
    end
  end

  context ".xml" do
    before do
      get :show, :q => 'Item', :format => 'xml', :context => 'items'
    end

    it { should respond_with(:success) }

    # TODO: Replace with feature
    it "should not include certain fields" do
      # response.should_not have_text('created_at')
      # response.should_not have_text('updated_at')
    end
  end
end

describe SearchesController, "members" do
  before do
    @members = []
    2.times { @members << Factory(:member) }
  end

  subject { controller }

  context ".html" do
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
      it { should assign_to(:members).with_kind_of(Array) }
    end
  end

  context ".js" do
    before do
      get :show, :q => 'Member', :format => 'js', :context => 'members'
    end

    it { should respond_with(:success) }

    # TODO: Replace with feature
    it "should not include certain fields" do
      # response.should_not have_text('created_at')
      # response.should_not have_text('updated_at')
    end
  end

  context ".json" do
    before do
      get :show, :q => 'Member', :format => 'json', :context => 'members'
    end

    it { should respond_with(:success) }

    # TODO: Replace with feature
    it "should not include certain fields" do
      # response.should_not have_text('created_at')
      # response.should_not have_text('updated_at')
    end
  end

  context ".xml" do
    before do
      get :show, :q => 'Member', :format => 'xml', :context => 'members'
    end

    it { should respond_with(:success) }

    # TODO: Replace with feature
    it "should not include certain fields" do
      # response.should_not have_text('created_at')
      # response.should_not have_text('updated_at')
    end
  end
end
