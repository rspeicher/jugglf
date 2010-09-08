require 'spec_helper'

describe UserSessionsController, "routing" do
  it { should route(:get,    '/login').to(:controller => :user_sessions, :action => :new) }
  # FIXME: Don't know why this is failing now
  # it { should route(:delete, '/logout').to(:controller => :user_sessions, :action => :destroy, :method => :delete) }
  it { should route(:post,   '/user_session').to(:controller => :user_sessions, :action => :create) }
  it { should route(:delete, '/user_session').to(:controller => :user_sessions, :action => :destroy) }
end

describe UserSessionsController, "GET new" do
  before do
    logout
    get :new
  end

  it { should assign_to(:user_session) }
  it { should render_template(:new) }
end

describe UserSessionsController, "POST create" do
  context "success" do
    before do
      logout
      @user_session = mock(:save => true)
      UserSession.stubs(:find).returns(nil) # current_user_session
      UserSession.expects(:new).returns(@user_session)
      post :create, :user_session => {}
    end

    it { should set_the_flash.to(/success/) }
    it { should redirect_to(members_path) }
  end

  context "failure" do
    before do
      logout
      post :create, :user_session => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe UserSessionsController, "DELETE destroy" do
  before do
    delete :destroy
  end

  it { should set_the_flash.to(/success/) }
  it { should redirect_to(root_url) }
end
