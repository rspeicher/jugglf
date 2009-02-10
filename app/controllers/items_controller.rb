class ItemsController < ApplicationController
  layout 'poison'
  
  def index
    @items = Item.paginate(:page => params[:page], :per_page => 100, :include => :raid, :order => "raids.date DESC")
    
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
