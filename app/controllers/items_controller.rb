class ItemsController < ApplicationController
  layout 'poison'
  
  def index
    @items = Item.find(:all, :order => "created_at DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    @item = Item.find(params[:id])
    # @purchases = Item.find_all_by_name(@item.name)
    @purchases = Item.find(:all, :include => :raid, :conditions => ["name = ?", @item.name]) 
    
    respond_to do |wants|
      wants.html
    end
  end
end
