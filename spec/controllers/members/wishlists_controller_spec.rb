require 'spec_helper'

describe Members::WishlistsController, "routing" do
  it { should route(:get,    '/members/1/wishlists'       ).to(:controller => 'members/wishlists', :action => :index,   :member_id => '1') }
  it { should route(:post,   '/members/1/wishlists'       ).to(:controller => 'members/wishlists', :action => :create,  :member_id => '1') }
  it { should route(:get,    '/members/1/wishlists/new'   ).to(:controller => 'members/wishlists', :action => :new,     :member_id => '1') }
  it { should route(:get,    '/members/1/wishlists/2/edit').to(:controller => 'members/wishlists', :action => :edit,    :member_id => '1', :id => '2') }
  it { should route(:put,    '/members/1/wishlists/2'     ).to(:controller => 'members/wishlists', :action => :update,  :member_id => '1', :id => '2') }
  it { should route(:delete, '/members/1/wishlists/2'     ).to(:controller => 'members/wishlists', :action => :destroy, :member_id => '1', :id => '2') }
end

describe Members::WishlistsController, "GET index" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    get :index, :member_id => @parent.id
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:wishlist).with_kind_of(Wishlist) }
  it { should assign_to(:wishlists).with_kind_of(Array) }
  it { should assign_to(:recent_loots).with_kind_of(Array) }
  it { should render_template(:index) }
end

describe Members::WishlistsController, "GET new" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    get :new, :member_id => @parent.id
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:wishlist).with_kind_of(Wishlist) }
  it { should render_template(:edit) } # Intentional
end

describe Members::WishlistsController, "GET edit" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    mock_find(:wishlist)
    get :edit, :member_id => @parent.id, :id => @wishlist.id
  end
  
  it { should respond_with(:success) }
  it { should assign_to(:wishlist).with(@wishlist) }
  it { should render_template(:edit) }
end

describe Members::WishlistsController, "POST create" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
  end

  context "success" do
    before(:each) do
      mock_create(:wishlist, :save => true)
      post :create, :member_id => @parent.id, :wishlist => {}
    end
    
    it { should set_the_flash.to(/successfully created/) }
    it { should redirect_to(member_path(@parent)) }
  end
  
  context "failure" do
    before(:each) do
      mock_create(:wishlist, :save => false)
      post :create, :member_id => @parent.id, :wishlist => {}
    end
    
    it { should set_the_flash.to(/could not be created/) }
    it { should render_template(:new) }
  end
end

describe Members::WishlistsController, "PUT update" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
  end
  
  context "success" do
    before(:each) do
      mock_find(:wishlist, :update_attributes => true)
      put :update, :member_id => @parent.id, :id => @wishlist.id
    end
    
    it { should set_the_flash.to(/successfully updated/) }
    it { should redirect_to(member_path(@parent)) }
  end
  
  context "failure" do
    before(:each) do
      mock_find(:wishlist, :update_attributes => false)
      put :update, :member_id => @parent.id, :id => @wishlist.id
    end
    
    it { should set_the_flash.to(/could not be updated/) }
    it { should render_template(:edit) }
  end
end

describe Members::WishlistsController, "DELETE destroy" do
  before(:each) do
    login(:admin)
    mock_parent(:member)
    mock_find(:wishlist, :destroy => true)
    delete :destroy, :member_id => @parent.id, :id => @wishlist.id
  end
  
  it { should set_the_flash.to(/deleted/) }
  it { should redirect_to(member_path(@parent)) }
end