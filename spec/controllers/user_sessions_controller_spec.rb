require 'spec_helper'

describe UserSessionsController, "routing" do
  it { should route(:get, '/login').to(:controller => :user_sessions, :action => :new) }
  it { should route(:delete, '/logout').to(:controller => :user_sessions, :action => :destroy, :method => :delete) }
  it { should route(:post, '/user_session').to(:controller => :user_sessions, :action => :create) }
  it { should route(:delete, '/user_session').to(:controller => :user_sessions, :action => :destroy) }
end

describe UserSessionsController, "GET new" do
  before(:each) do
    get :new
  end

  it { should assign_to(:user_session) }
  it { should render_template(:new) }
end

describe UserSessionsController, "POST create" do
  context "success" do
    before(:each) do
      @user_session = mock_model(UserSession, :save => true)
      UserSession.stub!(:find).and_return(nil) # current_user_session
      UserSession.should_receive(:new).and_return(@user_session)
      post :create, :user_session => {}
    end

    it { should set_the_flash.to(/success/) }
    it { should redirect_to(members_path) }
  end

  context "failure" do
    before(:each) do
      post :create, :user_session => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe UserSessionsController, "DELETE destroy" do
  before(:each) do
    login
    delete :destroy
  end

  it { should set_the_flash.to(/success/) }
  it { should redirect_to(root_url) }
end