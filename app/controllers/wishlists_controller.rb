class WishlistsController < ApplicationController
  layout @@layout
  
  before_filter :require_user
  
  before_filter :find_wishlist, :only => [:edit, :update, :destroy]
  
  def index
    @wishlist = Wishlist.new # Used in remote_form_for tag
    @wishlists = Wishlist.find(:all, :include => [{ :item => :item_stat }], 
      :conditions => ['member_id = ?', 150])#@current_member.id]) # TODO: Current member
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def new
    @wishlist = Wishlist.new
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def edit
    respond_to do |wants|
      wants.html do
        if request.xhr?
          render :action => 'edit_inline'
        else
          render :action => 'edit'
        end
      end
    end
  end
  
  def create
    @wishlist = Wishlist.new(params[:wishlist])
    
    respond_to do |wants|
      if @wishlist.save
        wants.html do
          flash[:success] = "Wishlist entry was successfully created."
          redirect_to(wishlists_path)
        end
        wants.js { render :partial => 'create', :object => @wishlist, :locals => { :success => true } }
      else
        wants.html { render :action => 'new' }
        wants.js { render :partial => 'create', :object => @wishlist, :locals => { :success => false } }
      end
    end
  end
  
  def update
    respond_to do |wants|
      if @wishlist.update_attributes(params[:wishlist])
        wants.html do
          flash[:success] = "Wishlist entry was successfully updated."
          redirect_to(wishlists_path)
        end
        wants.js { render :partial => 'update', :object => @wishlist, :locals => { :success => true } }
      else
        wants.html { render :action => "edit" }
        wants.js { render :partial => 'update', :object => @wishlist, :locals => { :success => false } }
      end
    end
  end
  
  def destroy
    @wishlist.destroy
    
    respond_to do |wants|
      wants.html do
        flash[:success] = "Wishlist entry was successfully deleted."
        redirect_to(wishlists_path)
      end
      wants.js do
        head interpret_status(:ok) # TODO: Is this the right way to do this?
      end
    end
  end
  
  private
    def find_wishlist
      @wishlist = Wishlist.find(params[:id], :conditions => ['member_id = ?', 150])#@current_member.id]) # TODO: Current member
    end
end
