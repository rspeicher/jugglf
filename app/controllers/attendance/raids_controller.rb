class Attendance::RaidsController < ApplicationController
  before_filter :require_admin
  
  def index
    @raids = LiveRaid.find(:all, :order => 'id DESC')
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    @live_raid = LiveRaid.find(params[:id])
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def new
    @live_raid = LiveRaid.new
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    @live_raid = LiveRaid.new(params[:live_raid])
    
    respond_to do |wants|
      if @live_raid.save
        wants.html { redirect_to live_raid_path(@live_raid) }
      else
        wants.html { render :action => :new }
      end
    end
  end
end
