class ItemsController < ApplicationController
  before_filter :find_item, :only => [:show]
  
  def show
    @loots = @item.loots.find(:all, :include => :member)
    @wishlists = @item.wishlists.find(:all, :include => :member)
    
    respond_to do |wants|
      wants.html
    end
  end
  
  private
    def find_item
      @item = Item.find(params[:id])
    end
end
