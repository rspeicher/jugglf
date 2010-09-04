class ItemsController < ApplicationController
  before_filter :require_admin, :except => [:index, :show]
  before_filter :find_item, :only => [:show, :edit, :update, :destroy]

  def index
    @items = Item.order(:name).paginate(:page => params[:page], :per_page => 35)

    respond_to do |wants|
      wants.html
    end
  end

  def show
    @loots = @item.loots.includes(:member).order('purchased_on DESC').paginate(:page => params[:page], :per_page => 35)
    @wishlists = @item.wishlists.where("#{Member.table_name}.active = ?", true).includes(:member)
    @loot_table = LootTable.where(:object_type => 'Item', :object_id => @item.id).first

    respond_to do |wants|
      wants.html
    end
  end

  def new
    @item = Item.new

    respond_to do |wants|
      wants.html
    end
  end

  def edit
    respond_to do |wants|
      wants.html
    end
  end

  def create
    @item = Item.new(params[:item])

    respond_to do |wants|
      if @item.save
        flash[:success] = 'Item was successfully created.'
        wants.html { redirect_to(item_path(@item)) }
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
