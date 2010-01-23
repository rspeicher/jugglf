require 'spec_helper'

describe Search::ItemsController, "routing" do
  it { should route(:get, '/search/items'     ).to(:controller => 'search/items', :action => :index) }
  it { should route(:get, '/search/items.json').to(:controller => 'search/items', :action => :index, :format => 'json') }
end

describe Search::ItemsController, "GET index" do
  before(:each) do
    @items = []
    2.times { @items << Factory(:item) }
  end

  context ".html" do
    context "with exact match" do
      before(:each) do
        get :index, :q => @items[0].name
      end

      it { should redirect_to(item_path(@items[0])) }
    end

    context "with multiple matches" do
      before(:each) do
        get :index, :q => 'Item'
      end

      it { should respond_with(:success) }
      it { should render_template('items/index') }
      it { should assign_to(:items).with_kind_of(Array) }
    end
  end

  context ".js" do
    before(:each) do
      get :index, :q => 'Item', :format => 'js'
    end

    it { should respond_with(:success) }
    it "should not include certain fields" do
      response.should_not have_text('created_at')
      response.should_not have_text('updated_at')
    end
  end

  context ".json" do
    before(:each) do
      get :index, :q => 'Item', :format => 'json'
    end

    it { should respond_with(:success) }
    it "should not include certain fields" do
      response.should_not have_text('created_at')
      response.should_not have_text('updated_at')
    end
  end

  context ".xml" do
    before(:each) do
      get :index, :q => 'Item', :format => 'xml'
    end

    it { should respond_with(:success) }
    it "should not include certain fields" do
      response.should_not have_text('created_at')
      response.should_not have_text('updated_at')
    end
  end
end