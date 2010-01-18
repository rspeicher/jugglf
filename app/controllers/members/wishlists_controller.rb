class Members::WishlistsController < ApplicationController
  before_filter :require_user
  
  before_filter :find_parent
  before_filter :find_wishlist, :only => [:edit, :update, :destroy]
  
  before_filter :prepare_params, :only => [:create, :update]
  
  skip_before_filter :verify_authenticity_token, :only => [:create]
  
  def index
    @wishlist     = Wishlist.new # Let the "Add New" form work
    @wishlists    = @member.wishlists
    @recent_loots = @member.loots.find(:all, :conditions => ['purchased_on >= ?', 2.weeks.ago])

    respond_to do |wants|
      wants.html
      wants.lua
    end
  end
  
  def new
    @wishlist = Wishlist.new
    
    respond_to do |wants|
      wants.html { render :action => 'edit' }
    end
  end
  
  def edit
    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    @wishlist = @parent.wishlists.new(params[:wishlist])
    
    respond_to do |wants|
      if @wishlist.save
        flash[:success] = "Wishlist entry was successfully created."
        wants.html { redirect_to member_path(@parent) }
        wants.js
      else
        flash[:error] = "Wishlist entry could not be created."
        wants.html { render :action => 'new' }
        wants.js
      end
    end
  end
  
  def update
    respond_to do |wants|
      if @wishlist.update_attributes(params[:wishlist])
        flash[:success] = "Wishlist entry was successfully updated."
        wants.html { redirect_to member_path(@parent) }
        wants.js
      else
        flash[:error] = "Wishlist entry could not be updated."
        wants.html { render :action => "edit" }
        wants.js
      end
    end
  end
  
  def destroy
    @wishlist.destroy
    
    respond_to do |wants|
      wants.html do
        flash[:success] = "Wishlist entry was successfully deleted."
        redirect_to(member_path(@parent))
      end
      wants.js { head :ok }
    end
  end
  
  private
    def find_parent
      if current_user.is_admin?
        @parent = @member = Member.find(params[:member_id])
      else
        # Scope to the current user
        @parent = @member = current_user.member
        require_admin if @parent.nil?
      end
    end
    
    def find_wishlist
      @wishlist = @parent.wishlists.find(params[:id])
    end
    
    def prepare_params
      # If given the item's exact ID, we don't need to know its name
      return unless params[:wishlist].present? and params[:wishlist][:wow_id].present?
      params[:wishlist].delete(:item_name) if params[:wishlist][:wow_id].present?
    end
end
