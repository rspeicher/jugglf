class Members::PunishmentsController < ApplicationController
  before_filter :require_user

  before_filter :find_parent
  before_filter :find_punishment, :only => [:edit, :update, :destroy]

  def index
    @punishments = @parent.punishments

    respond_to do |wants|
      wants.html
    end
  end

  def new
    @punishment = @parent.punishments.new

    respond_to do |wants|
      wants.html
    end
  end

  def edit
    respond_to do |wants|
      wants.html
    end
  end

  def create
    @punishment = @member.punishments.new(params[:punishment])

    respond_to do |wants|
      if @punishment.save
        flash[:success] = "Punishment was successfully created."
        wants.html { redirect_to member_path(@member) }
      else
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |wants|
      if @punishment.update_attributes(params[:punishment])
        flash[:success] = "Punishment was successfully updated."
        wants.html { redirect_to member_path(@member) }
      else
        wants.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @punishment.destroy

    flash[:success] = "Punishment was successfully deleted."
    respond_to do |wants|
      wants.html { redirect_to member_path(@parent) }
    end
  end

  private
    def find_parent
      if current_user.is_admin?
        @parent = @member = Member.find(params[:member_id])
      else
        # Scope to the current user
        @parent = @member = current_user.member
      end
    end

    def find_punishment
      @punishment = @member.punishments.find(params[:id])
    end
end
