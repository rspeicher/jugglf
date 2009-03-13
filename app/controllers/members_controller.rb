class MembersController < ApplicationController
  layout @@layout
  
  # Viewing a member requires a user of some type
  before_filter :require_user,                :only   => [:show]
  
  # Doing anything else with members requires admin
  before_filter :require_admin,               :except => [:index, :show]
  
  # Viewing a member may or may not require admin, depending if the user is viewing their own member entry
  before_filter :require_admin_conditionally, :only   => [:show]
  
  # Find the given member
  before_filter :find_member,                 :only   => [:show, :edit, :update, :destroy]
  
  def index
    @members = Member.active(:include => :rank)

    respond_to do |wants|
      wants.html
      wants.lua
    end
  end
  
  def show
    respond_to do |wants|
      wants.html do
        case params[:tab]
        when 'raids'
          @raids = Raid.paginate(:page => params[:page], :per_page => 35, 
            :include => [:attendees], :order => "date DESC")
        when 'loots'
          @loots = @member.loots.find(:all, :include => [{:item => :item_stat}])
        when 'punishments'
          @punishments = @member.punishments.active
        when 'wishlist'
          @wishlists = @member.wishlists
          @wishlist = Wishlist.new
        when 'achievements'
          @achievements = Achievement.find(:all, :order => 'title')
          @completed = @member.completed_achievements
        end
        
        if params[:tab]
          render :partial => "members/#{params[:tab]}"
        else
          render :action => :show
        end
      end
    end
  end
  
  def new
    @member = Member.new
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def edit
    @users = InvisionUser.juggernaut
    
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
    respond_to do |wants|
      if @member.update_attributes(params[:member])
        flash[:success] = 'Member was successfully updated.'
        wants.html { redirect_to(@member) }
      else
        wants.html { render :action => "edit" }
      end
    end
  end
  
  private
    def require_admin_conditionally
      # Render regardless for admins
      if current_user.is_admin?
        return true
      # Not an admin, no associated member; bounce to index
      elsif current_user.member.nil? and not current_user.is_admin?
        require_admin
      # Not an admin, current member is not associated member; bounce to index
      elsif current_user.member.id != params[:id] and not current_user.is_admin?
        require_admin
      end
    end
    
    def find_member
      @member = Member.find(params[:id])
    end
end
