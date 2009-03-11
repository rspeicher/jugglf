class ItemsController < ApplicationController
  before_filter :find_item, :only => [:show]
  
  def index
    @items = Item.paginate(:page => params[:page], :per_page => 35, :order => 'name')
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    @loots = @item.loots.find(:all, :include => :member)
    @wishlists = @item.wishlists.find(:all, :include => :member, :conditions => ["#{Member.table_name}.active = ?", true])
    
    respond_to do |wants|
      wants.html
    end
  end
  
  private
    def find_item
      @item = Item.find(params[:id])
    end
end
