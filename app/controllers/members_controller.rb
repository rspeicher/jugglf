class MembersController < ApplicationController
  layout @@layout
  
  before_filter :find_member,   :only   => [:show, :edit, :update, :destroy]
  before_filter :require_user,  :only   => [:show]
  before_filter :require_admin, :except => [:show]
  
  def index
    @members = Member.find_all_by_active(true, :order => "name asc", :include => :rank)

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
          @punishments = @member.punishments.find_all_active
        when 'wishlists'
          @wishlists = @member.wishlists
          @wishlist = Wishlist.new
        when 'achievements'
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
    def find_member
      @member = Member.find(params[:id])
    end
end
