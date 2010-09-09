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
  before do
    @parent = Factory(:member)
    get :index, :member_id => @parent
  end

  it { should respond_with(:success) }
  it { should assign_to(:punishments) }
  it { should render_template(:index) }
end

describe Members::PunishmentsController, "GET new" do
  before do
    @parent = Factory(:member)
    get :new, :member_id => @parent
  end

  it { should respond_with(:success) }
  it { should assign_to(:punishment).with_kind_of(Punishment) }
  it { should render_template(:new) }
end

describe Members::PunishmentsController, "GET edit" do
  before do
    @parent   = Factory(:member)
    @resource = Factory(:punishment, :member => @parent)
    get :edit, :member_id => @parent, :id => @resource
  end

  it { should respond_with(:success) }
  it { should assign_to(:punishment).with(@resource) }
  it { should render_template(:edit) }
end

describe Members::PunishmentsController, "POST create" do
  before do
    @parent = Factory(:member)
    Member.stubs(:find).returns(@parent)
  end

  context "success" do
    before do
      @parent.stubs(:punishments).returns(mock(:new => mock(:save => true)))
      post :create, :member_id => @parent, :punishment => {}
    end

    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(member_path(@parent)) }
  end

  context "failure" do
    before do
      @parent.stubs(:punishments).returns(mock(:new => mock(:save => false)))
      post :create, :member_id => @parent, :punishment => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:new) }
  end
end

describe Members::PunishmentsController, "PUT update" do
  before do
    @parent   = Factory(:member)
    @resource = Factory(:punishment, :member => @parent)
  end

  context "success" do
    before do
      Punishment.any_instance.expects(:update_attributes).with({}).returns(true)
      put :update, :member_id => @parent, :id => @resource, :punishment => {}
    end

    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(member_path(@parent)) }
  end

  context "failure" do
    before do
      Punishment.any_instance.expects(:update_attributes).with({}).returns(false)
      put :update, :member_id => @parent, :id => @resource, :punishment => {}
    end

    it { should_not set_the_flash }
    it { should render_template(:edit) }
  end
end

describe Members::PunishmentsController, "DELETE destroy" do
  before do
    @parent   = Factory(:member)
    @resource = Factory(:punishment, :member => @parent)
    delete :destroy, :member_id => @parent, :id => @resource
  end

  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(member_path(@parent)) }
end
