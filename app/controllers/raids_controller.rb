class RaidsController < ApplicationController
  layout @@layout
  
  before_filter :require_admin
  
  before_filter :find_raid, :only => [:show, :edit, :update, :destroy]
  
  def index
    @raids = Raid.paginate(:page => params[:page], :per_page => 40, :order => "date DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    logger.debug 'Finding attendees'
    @attendees = Attendee.find(:all, :conditions => ['raid_id = ?', @raid.id],
      :include => :member)
    logger.debug 'Finding loots'
    @loots     = Loot.find(:all, :conditions => ['raid_id = ?', @raid.id], 
      :include => [{:item => :item_stat}, :member])
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def new
    @raid = Raid.new

    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    @raid = Raid.new(params[:raid])
  
    respond_to do |wants|
      if @raid.save
        flash[:success] = 'Raid was successfully created.'
        wants.html { redirect_to(@raid) }
      else
        wants.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @raid.destroy
    
    flash[:success] = "Raid was successfully deleted."
    
    respond_to do |wants|
      wants.html { redirect_to(raids_path) }
    end
  end
  
  private
    def find_raid
      @raid = Raid.find(params[:id])
    end
end
