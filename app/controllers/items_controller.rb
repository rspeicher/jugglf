class ItemsController < ApplicationController
  layout @@layout
  
  def index
    @items = Item.paginate(:page => params[:page], :per_page => 40, :include => :raid, :order => "#{Raid.table_name}.date DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    @item = Item.find(params[:id])
    # @purchases = Item.find_all_by_name(@item.name)
    @purchases = Item.find(:all, :include => :raid, :order => "#{Raid.table_name}.date DESC", :conditions => ["name = ?", @item.name])
    
    respond_to do |wants|
      wants.html
    end
  end
end
