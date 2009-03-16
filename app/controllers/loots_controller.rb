class LootsController < ApplicationController
  before_filter :require_admin
  before_filter :find_loot, :only => [:show, :edit, :update, :destroy]
  before_filter :raids_select, :only => [:new, :edit]
  
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
    page_title('Edit Loot')
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    @loot = Loot.new(params[:loot])
  
    respond_to do |wants|
      if @loot.save
        flash[:success] = 'Loot was successfully created.'
        wants.html { redirect_to(loots_path) }
      else
        wants.html do
          raids_select
          render :action => "new"
        end
      end
    end
  end
  
  def update
    respond_to do |wants|
      if @loot.update_attributes(params[:loot])
        flash[:success] = 'Loot was successfully updated.'
        wants.html { redirect_to(loots_path) }
      else
        wants.html do
          raids_select
          render :action => 'edit'
        end
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
    
    def raids_select
      @raids = Raid.find(:all, :order => 'date DESC', 
        :conditions => ['date >= ?', 52.days.until(Date.today)])      
    end
end
