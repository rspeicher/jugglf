class WishlistsController < ApplicationController
  before_filter :require_user
  
  before_filter :find_wishlist, :only => :destroy
  
  def index
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
      if @wishlist.save
        flash[:success] = "Wishlist entry was successfully created."
        wants.html { redirect_to(wishlists_path) }
      else
        wants.html { render :action => 'new' }
      end
    end
  end
  
  def destroy
    @wishlist.destroy
    
    flash[:success] = "Wishlist entry was successfully deleted."
    
    respond_to do |wants|
      wants.html { redirect_to(wishlists_path) }
    end
  end
  
  private
    def find_wishlist
      @wishlist = Wishlist.find(params[:id])
    end
end
