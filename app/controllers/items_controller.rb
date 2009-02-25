class ItemsController < ApplicationController
  before_filter :find_item, :only => [:show, :edit, :update, :destroy]
  
  layout @@layout
  
  def index
    @items = Item.paginate(:page => params[:page], :per_page => 40, :include => :raid, :order => "#{Raid.table_name}.date DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    @purchases = Item.find(:all, :include => :raid, :order => "#{Raid.table_name}.date DESC", :conditions => ["name = ?", @item.name])
    
    respond_to do |wants|
      wants.html
    end
  end
  
  private
    def find_item
      @item = Item.find(params[:id])
    end
end
