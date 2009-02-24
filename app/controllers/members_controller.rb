class MembersController < ApplicationController
  layout @@layout
  
  def index
    @members = Member.find_all_by_active(true, :order => "name asc")

    respond_to do |wants|
      wants.html
      wants.lua
    end
  end
  
  def show
    @member = Member.find(params[:id])
    @raids_count = Raid.count
    @raids = Raid.paginate(:page => params[:page], :per_page => 50, :order => "date DESC")
    @punishments = @member.punishments.find_all_active
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def new
    @member = Member.new
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def edit
    @member = Member.find(params[:id])
    raise if @member.nil?
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    @member = Member.new(params[:member])
  
    respond_to do |wants|
      if @member.save
        flash[:success] = 'Member was successfully created.'
        wants.html { redirect_to(@member) }
      else
        wants.html { render :action => "new" }
      end
    end
  end
  
  def update
    @member = Member.find(params[:id])

    respond_to do |wants|
      if @member.update_attributes(params[:member])
        flash[:success] = 'Member was successfully updated.'
        wants.html { redirect_to(@member) }
      else
        wants.html { render :action => "edit" }
      end
    end
  end
end
