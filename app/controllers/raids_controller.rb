class RaidsController < ApplicationController
  layout 'poison'
  
  def index
    @raids = Raid.find(:all, :order => "date DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    @raid = Raid.find(params[:id])
    @attendees = @raid.attendees.find(:all, :include => :member, :order => "members.wow_class, members.name")
    @drops     = @raid.items.find(:all, :include => :member, :order => "items.name")
    
    respond_to do |wants|
      wants.html
    end
  end
end
