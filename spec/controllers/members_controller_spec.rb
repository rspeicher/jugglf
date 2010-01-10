require 'spec_helper'

module MembersHelperMethods
  def mock_find
    @member ||= Factory(:member)
    Member.should_receive(:find).with(anything()).and_return(@member)
  end
  
  def mock_new
    @member ||= Factory(:member)
    Member.should_receive(:new).with(anything()).and_return(@member)
  end
  
  def mock_field_collections
    User.should_receive(:juggernaut).and_return([])
    MemberRank.should_receive(:find).with(:all, anything()).and_return([])
  end
end

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
  before(:each) do
    login(:admin)
  end
  
  context ".html" do
    before(:each) do
      get :index
    end
  
    it { should respond_with(:success) }
    it { should assign_to(:members).with_kind_of(Array) }
    it { should render_template(:index) }
  end
  
  context ".lua" do
    before(:each) do
      get :index, :format => 'lua'
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:members).with_kind_of(Array) }
    it { should render_template(:index) }
  end
end

describe MembersController, "GET show" do
  include MembersHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    get :show, :id => @member
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:member).with(@member) }
  it { should render_template(:show) }
end

describe MembersController, "GET new" do
  before(:each) do
    login(:admin)
    get :new
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:member).with_kind_of(Member) }
  it { should render_template(:new) }  
end

describe MembersController, "GET edit" do
  include MembersHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    mock_field_collections
    get :edit, :id => @member
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:member).with(@member) }
  it { should assign_to(:users).with_kind_of(Array) }
  it { should assign_to(:ranks).with_kind_of(Array) }
  it { should render_template(:edit) }
end

describe MembersController, "POST create" do
  include MembersHelperMethods

  before(:each) do
    login(:admin)
    mock_new
  end

  context "success" do
    before(:each) do
      @member.should_receive(:save).and_return(true)
      post :create, :member => {}
    end
    
    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(member_path(@member)) }
  end
  
  context "failure" do
    before(:each) do
      @member.should_receive(:save).and_return(false)
      post :create, :member => {}
    end
    
    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe MembersController, "PUT update" do
  include MembersHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
  end
  
  context "success" do
    before(:each) do
      @member.should_receive(:update_attributes).with(anything()).and_return(true)
      put :update, :id => @member
    end
    
    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(members_path) }
  end
  
  context "failure" do
    before(:each) do
      @member.should_receive(:update_attributes).with(anything()).and_return(false)
      put :update, :id => @member
    end
    
    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe MembersController, "DELETE destroy" do
  include MembersHelperMethods
  
  before(:each) do
    login(:admin)
    mock_find
    @member.should_receive(:destroy)
    delete :destroy, :id => @member
  end
  
  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(members_path) }
end