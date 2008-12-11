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
    
    respond_to do |wants|
      wants.html
    end
  end
end
