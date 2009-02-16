class RaidsController < ApplicationController
  layout @@layout
  
  def index
    @raids = Raid.paginate(:page => params[:page], :per_page => 40, :order => "date DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def show
    @raid      = Raid.find(params[:id])
    @attendees = @raid.attendees.find(:all, :include => :member, :order => "members.wow_class, members.name")
    @drops     = @raid.items.find(:all, :include => :member, :order => "items.name")
    
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
        flash[:notice] = 'Raid was successfully created.'
        wants.html { redirect_to(@raid) }
        wants.xml  { render :xml => @raid, :status => :created, :location => @raid }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @raid.errors, :status => :unprocessable_entity }
      end
    end
  end
end
