class LootsController < ApplicationController
  before_filter :require_admin
  before_filter :find_loot, :only => [:show, :edit, :update, :destroy]
  
  layout @@layout
  
  def index
    page_title('Loot History')
    
    @loots = Loot.paginate(:page => params[:page], :per_page => 40, 
      :include => [{:item => :item_stat}, :raid, :member], 
      :order => "purchased_on DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def new
    page_title('New Loot')
    
    @loot = Loot.new
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def edit
    page_title(@loot.item.name, 'Edit Loot')
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    @loot = Loot.new(params[:loot])
  
    respond_to do |wants|
      if @loot.save
        flash[:success] = 'Loot was successfully created.'
        wants.html { redirect_to(@loot) }
      else
        wants.html { render :action => "new" }
      end
    end
  end
  
  def update
    respond_to do |wants|
      if @loot.update_attributes(params[:loot])
        flash[:success] = 'Loot was successfully updated.'
        wants.html { redirect_to(loot_path(@loot)) }
      else
        wants.html { render :action => 'edit' }
      end
    end
  end
  
  def destroy
    @loot.destroy
    
    flash[:success] = 'Loot was successfully deleted.'
    
    respond_to do |wants|
      wants.html { redirect_to(loots_path) }
    end
  end
  
  private
    def find_loot
      @loot = Loot.find(params[:id])
    end
end
