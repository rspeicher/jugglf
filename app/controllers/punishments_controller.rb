class PunishmentsController < ApplicationController
  layout @@layout
  
  before_filter :find_parent
  
  def index
    respond_to do |wants|
      wants.html do
        if @parent.nil?
          render
        else
          redirect_to(member_path(@member) + '#punishments')
        end
      end
    end
  end
  
  def new
    @punishment = Punishment.new
    
    respond_to do |wants|
      wants.html do
        if @parent.nil?
          #TODO
        else
          render
        end
      end
    end
  end
  
  def create
    @punishment = @member.punishments.create(params[:punishment])
    
    respond_to do |wants|
      if @punishment.save
        flash[:success] = "Punishment was successfully added to #{@member.name}"
        wants.html { redirect_to(member_path(@member) + '#punishments') }
      else
        wants.html { render :action => "new" }
      end
    end
  end
  
  def edit
    @punishment = Punishment.find(params[:id])
    
    respond_to do |wants|
      wants.html
    end
  end
  
  protected
    def find_parent
      if params[:member_id]
        @parent = @member = Member.find(params[:member_id])
      end
    end
end
