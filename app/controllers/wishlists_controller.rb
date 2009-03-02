class WishlistsController < ApplicationController
  before_filter :require_user
  
  before_filter :find_wishlist, :only => :destroy
  
  def index
    @wishlist = Wishlist.new # Used in remote_form_for tag
    @wishlists = Wishlist.find(:all)
    
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
  
  def create
    @wishlist = Wishlist.new(params[:wishlist])
    
    respond_to do |wants|
      if true# @wishlist.save
        wants.html do
          flash[:success] = "Wishlist entry was successfully created."
          redirect_to(wishlists_path)
        end
        wants.js { render :partial => 'create_success', :object => @wishlist }
      else
        wants.html { render :action => 'new' }
        wants.js do
        end
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
      @wishlist = Wishlist.find(params[:id])
    end
end
