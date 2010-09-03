class MembersController < ApplicationController
  before_filter :require_user,      :except => [:index]
  before_filter :require_admin,     :except => [:index, :show] # Members can view their own standing ONLY
  before_filter :find_member,       :except => [:index, :new, :create]
  before_filter :field_collections, :except => [:index, :show, :destroy] # Populate the Rank and Invision User collections

  cache_sweeper :index_sweeper, :only => [:create, :update, :destroy]

  def index
    @members = Member.active.includes(:rank).all

    respond_to do |wants|
      wants.html
      wants.lua
    end
  end

  def show
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
    respond_to do |wants|
      wants.html
    end
  end

  def create
    @member = Member.new(params[:member])

    respond_to do |wants|
      if @member.save
        flash[:success] = 'Member was successfully created.'
        wants.html { redirect_to(member_path(@member)) }
      else
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |wants|
      if @member.update_attributes(params[:member])
        flash[:success] = 'Member was successfully updated.'
        wants.html { redirect_to(members_path) }
      else
        wants.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @member.destroy

    flash[:success] = "Member was successfully deleted."

    respond_to do |wants|
      wants.html { redirect_to(members_path) }
    end
  end

  private
    def field_collections
      @users = User.juggernaut
      @ranks = MemberRank.find(:all, :order => 'name')
    end

    def find_member
      if current_user.is_admin?
        @member = Member.find(params[:id])
      else
        # Scope to the current user
        @member = current_user.member
        require_admin if @member.nil?
      end
    end

    def single_access_allowed?
      action_name == 'index' and params[:format] == 'lua'
    end
end
