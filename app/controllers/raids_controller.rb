class RaidsController < ApplicationController
  before_filter :require_admin
  before_filter :find_raid, :only => [:show, :edit, :update, :destroy]

  cache_sweeper :index_sweeper, :only => [:create, :update, :destroy]

  def index
    @raids = Raid.order("date DESC").paginate(:page => params[:page], :per_page => 40)

    respond_to do |wants|
      wants.html
    end
  end

  def show
    @loots    = Loot.where(:raid_id => @raid.id).includes(:item, :member)

    # Group attendees by class
    @attendees = { }
    Member::WOW_CLASSES.each do |wow_class|
      @attendees[wow_class] = []
    end
    attendees = Attendee.where(:raid_id => @raid.id).includes(:member)
    attendees.each do |att|
      unless att.member.wow_class.nil?
        wow_class = att.member.wow_class
        @attendees[wow_class].push(att)
      end
    end

    respond_to do |wants|
      wants.html
    end
  end

  def new
    params[:date] ||= Date.today

    @raid = Raid.new(:date => params[:date])

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
    @raid = Raid.new(params[:raid])

    respond_to do |wants|
      if @raid.save
        flash[:success] = 'Raid was successfully created.'
        wants.html { redirect_to(raid_path(@raid)) }
      else
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |wants|
      if @raid.update_attributes(params[:raid])
        flash[:success] = 'Raid was successfully updated.'
        wants.html { redirect_to(raid_path(@raid)) }
      else
        wants.html { render :action => 'edit' }
      end
    end
  end

  def destroy
    @raid.destroy

    flash[:success] = "Raid was successfully deleted."

    respond_to do |wants|
      wants.html { redirect_to(raids_path) }
    end
  end

  private
    def find_raid
      @raid = Raid.find(params[:id])
    end
end
