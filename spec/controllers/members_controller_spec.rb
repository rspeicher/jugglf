require 'spec_helper'

describe MembersController, "routing" do
  it { should route(:get, '/members').to(:controller => :members, :action => :index) }
  it { should route(:get, '/members.lua').to(:controller => :members, :action => :index, :format => :lua) }
  it { should route(:get, '/members/1-member').to(:controller => :members, :action => :show, :id => '1-member') }
  it { should route(:get, '/members/new').to(:controller => :members, :action => :new) }
  it { should route(:get, '/members/1-member/edit').to(:controller => :members, :action => :edit, :id => '1-member') }
  it { should route(:post, '/members').to(:controller => :members, :action => :create) }
  it { should route(:put, '/members/1-member').to(:controller => :members, :action => :update, :id => '1-member') }
  it { should route(:delete, '/members/1-member').to(:controller => :members, :action => :destroy, :id => '1-member') }
end

describe MembersController, "GET index" do
  context ".html" do
    before do
      get :index
    end

    it { should respond_with(:success) }
    it { should assign_to(:members) }
    it { should render_template(:index) }
  end

  context ".lua" do
    before do
      get :index, :format => 'lua'
    end

    it { should respond_with(:success) }
    it { should assign_to(:members) }
    it { should render_template(:index) }
  end
end

describe MembersController, "GET show" do
  before do
    @resource = Factory(:member)
    get :show, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:member).with(@resource) }
  it { should render_template(:show) }
end

describe MembersController, "GET new" do
  before do
    get :new
  end

  it { should respond_with(:success) }
  it { should assign_to(:member).with_kind_of(Member) }
  it { should render_template(:new) }
end

describe MembersController, "GET edit" do
  before do
    @resource = Factory(:member)
    get :edit, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:member).with(@resource) }
  it { should assign_to(:users) }
  it { should assign_to(:ranks) }
  it { should render_template(:edit) }
end

describe MembersController, "POST create" do
  before do
    @resource = Factory.build(:member)
    Member.expects(:new).with({}).returns(@resource)
  end

  context "success" do
    before do
      post :create, :member => {}
    end

    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(member_path(@resource)) }
  end

  context "failure" do
    before do
      @resource.expects(:save).returns(false)
      post :create, :member => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe MembersController, "PUT update" do
  context "success" do
    before do
      Member.any_instance.expects(:update_attributes).with({}).returns(true)
      put :update, :id => Factory(:member), :member => {}
    end

    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(members_path) }
  end

  context "failure" do
    before do
      Member.any_instance.expects(:update_attributes).with({}).returns(false)
      put :update, :id => Factory(:member), :member => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe MembersController, "DELETE destroy" do
  before do
    @resource = Factory(:member)
    delete :destroy, :id => @resource
  end

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(members_path) }
end
