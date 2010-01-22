require 'spec_helper'

describe Members::PunishmentsController, "routing" do
  it { should route(:get,    '/members/1/punishments'       ).to(:controller => 'members/punishments', :action => :index,   :member_id => '1') }
  it { should route(:post,   '/members/1/punishments'       ).to(:controller => 'members/punishments', :action => :create,  :member_id => '1') }
  it { should route(:get,    '/members/1/punishments/new'   ).to(:controller => 'members/punishments', :action => :new,     :member_id => '1') }
  it { should route(:get,    '/members/1/punishments/2/edit').to(:controller => 'members/punishments', :action => :edit,    :member_id => '1', :id => '2') }
  it { should route(:put,    '/members/1/punishments/2'     ).to(:controller => 'members/punishments', :action => :update,  :member_id => '1', :id => '2') }
  it { should route(:delete, '/members/1/punishments/2'     ).to(:controller => 'members/punishments', :action => :destroy, :member_id => '1', :id => '2') }
end

describe Members::PunishmentsController, "GET index" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    get :index, :member_id => @parent.id
  end

  it { should respond_with(:success) }
  it { should assign_to(:punishments).with_kind_of(Array) }
  it { should render_template(:index) }
end

describe Members::PunishmentsController, "GET new" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    get :new, :member_id => @parent.id
  end

  it { should respond_with(:success) }
  it { should assign_to(:punishment).with_kind_of(Punishment) }
  it { should render_template(:new) }
end

describe Members::PunishmentsController, "GET edit" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    mock_find(:punishment)
    get :edit, :member_id => @parent.id, :id => @punishment.id
  end

  it { should respond_with(:success) }
  it { should assign_to(:punishment).with(@punishment) }
  it { should render_template(:edit) }
end

describe Members::PunishmentsController, "POST create" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
  end

  context "success" do
    before(:each) do
      mock_create(:punishment, :save => true)
      post :create, :member_id => @parent.id, :punishment => {}
    end

    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(member_path(@parent)) }
  end

  context "failure" do
    before(:each) do
      mock_create(:punishment, :save => false)
      post :create, :member_id => @parent.id, :punishment => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe Members::PunishmentsController, "PUT update" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
  end

  context "success" do
    before(:each) do
      mock_find(:punishment, :update_attributes => true)
      put :update, :member_id => @parent.id, :id => @punishment.id
    end

    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(member_path(@parent)) }
  end

  context "failure" do
    before(:each) do
      mock_find(:punishment, :update_attributes => false)
      put :update, :member_id => @parent.id, :id => @punishment.id
    end

    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe Members::PunishmentsController, "DELETE destroy" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    mock_find(:punishment, :destroy => true)
    delete :destroy, :member_id => @parent.id, :id => @punishment.id
  end

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(member_path(@parent)) }
end