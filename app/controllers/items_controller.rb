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
    @loot_table = LootTable.find(:first, :conditions => ['object_type = ? AND object_id = ?', 'Item', @item.id])
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def new
    page_title('New Item')
    
    @item = Item.new
    
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
  
  def create
    @item = Item.new(params[:item])
  
    respond_to do |wants|
      if @item.save
        flash[:success] = 'Item was successfully created.'
        wants.html { redirect_to(@item) }
      else
        wants.html { render :action => "new" }
      end
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
  
  def destroy
    @item.destroy
    
    flash[:success] = "Item was successfully deleted."
    
    respond_to do |wants|
      wants.html { redirect_to(items_path) }
    end
  end
  
  private
    def find_item
      @item = Item.find(params[:id])
    end
end
