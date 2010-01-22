require 'spec_helper'

describe WishlistsController, "routing" do
  it { should route(:get, '/wishlists').to(:controller => :wishlists, :action => :index) }
end

describe WishlistsController, "GET index" do
  before(:each) do
    login(:admin)
  end

  context "without boss param" do
    before(:each) do
      get :index
    end

    it { should respond_with(:success) }
    it { should assign_to(:root).with_kind_of(Array) }
    it { should_not assign_to(:zone) }
    it { should_not assign_to(:boss) }
    it { should assign_to(:items).with([]) }
    it { should render_template(:index) }
  end

  context "with boss param" do
    # We got a boss param that exists, and it has items associated
    context "having items" do
      before(:each) do
        @object = Factory(:loot_table)
        get :index, :boss => @object.parent.id
      end

      it { should respond_with(:success) }
      it { should assign_to(:root).with_kind_of(Array) }
      it { should assign_to(:boss).with(@object.parent) }
      it { should assign_to(:zone).with(@object.parent.parent) }
      it { should assign_to(:recent_loots).with_kind_of(Array) }
      it { should assign_to(:items).with_kind_of(Array) }
      it { should render_template(:index) }
    end

    context "without items" do
      # We got a boss param that exists, but that boss has no items listed
      before(:each) do
        @object = Factory(:loot_table_boss)
        get :index, :boss => @object.id
      end

      it { should respond_with(:success) }
      it { should assign_to(:root).with_kind_of(Array) }
      it { should assign_to(:boss).with(@object) }
      it { should assign_to(:zone).with(@object.parent) }
      it { should_not assign_to(:recent_loots) }
      it { should assign_to(:items).with_kind_of(Array) }
      it { should render_template(:index) }
    end
  end
end