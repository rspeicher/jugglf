class PunishmentsController < ApplicationController
  layout @@layout
  
  before_filter :find_parent
  before_filter :find_punishment, :only => [:edit, :update, :destroy]
  
  def new
    @punishment = Punishment.new
    
    respond_to do |wants|
      wants.html do
        unless @parent.nil?
          render
        end
      end
    end
  end
  
  def edit
    respond_to do |wants|
      wants.html
    end
  end
  
  # Create / Update / Destroy -------------------------------------------------
  
  def create
    @punishment = @member.punishments.create(params[:punishment])
    
    respond_to do |wants|
      if @punishment.save
        flash[:success] = "Punishment was successfully created."
        wants.html { redirect_to(member_path(@member)) }
      else
        wants.html { render :action => "new" }
      end
    end
  end
  
  def update
    respond_to do |wants|
      if @punishment.update_attributes(params[:punishment])
        flash[:success] = "Punishment was successfully updated."
        wants.html { redirect_to(member_path(@member)) }
      else
        wants.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @punishment.destroy
    
    respond_to do |wants|
      wants.html { redirect_to(member_path(@member)) }
    end
  end
  
  protected
    def find_parent
      if params[:member_id]
        @parent = @member = Member.find(params[:member_id])
      end
    end
    
    def find_punishment
      @punishment = @member.punishments.find(params[:id])
    end
end
