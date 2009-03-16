class ItemsController < ApplicationController
  before_filter :require_admin, :except => [:index, :show]
  before_filter :find_item, :only => [:show, :edit, :update, :destroy]
  
  def index
    page_title('Items')
    
    @items = Item.paginate(:page => params[:page], :per_page => 35, :order => 'name')
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    page_title(@item.name)
    
    @loots = @item.loots.find(:all, :include => :member)
    @wishlists = @item.wishlists.find(:all, :include => :member, :conditions => ["#{Member.table_name}.active = ?", true])
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def edit
    page_title(@item.name, 'Edit')
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def update
    respond_to do |wants|
      if @item.update_attributes(params[:item])
        flash[:success] = 'Item was successfully updated.'
        wants.html { redirect_to(item_path(@item)) }
      else
        wants.html { render :action => 'edit' }
      end
    end
  end
  
  private
    def find_item
      @item = Item.find(params[:id])
    end
end
