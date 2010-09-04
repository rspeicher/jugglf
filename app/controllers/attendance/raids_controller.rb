class Attendance::RaidsController < ApplicationController
  before_filter :require_admin

  before_filter :find_raid, :except => [:index, :new, :create]

  skip_before_filter :verify_authenticity_token, :only => [:update]

  def index
    @raids = LiveRaid.order('id DESC')

    respond_to do |wants|
      wants.html
    end
  end

  def show
    respond_to do |wants|
      wants.html
    end
  end

  def new
    @live_raid = LiveRaid.new

    respond_to do |wants|
      wants.html
    end
  end

  def create
    @live_raid = LiveRaid.new(params[:live_raid])

    respond_to do |wants|
      if @live_raid.save
        wants.html { redirect_to live_raid_path(@live_raid) }
      else
        wants.html { render :action => :new }
      end
    end
  end

  def update
    @live_raid.attributes = params[:live_raid]

    if @live_raid.save
      respond_to do |wants|
        wants.html { redirect_to live_raid_path(@live_raid) }
      end
    else
      flash[:error] = "Failed to update the raid."
      respond_to do |wants|
        wants.html { redirect_to live_raid_path(@live_raid) }
      end
    end
  end

  def destroy
    @live_raid.destroy

    flash[:success] = "Raid was successfully deleted."
    respond_to do |wants|
      wants.html { redirect_to live_raids_path }
    end
  end

  def start
    @live_raid.start!

    respond_to do |wants|
      wants.html { redirect_to live_raid_path(@live_raid) }
    end
  end

  def stop
    @live_raid.stop!

    respond_to do |wants|
      wants.html { redirect_to live_raid_path(@live_raid) }
    end
  end

  def post
    require 'xmlrpc/client'

    if @live_raid.completed?
      server = XMLRPC::Client.new2('http://www.juggernautguild.com/interface/board/')

      response = server.call('postTopic', {
        :api_module   => 'ipb',
        :api_key      => Juggernaut[:ipb_api_key],
        :member_field => 'id',
        :member_key   => 4095, # Attendance
        :forum_id     => 10,
        :topic_title  => @live_raid.started_at.to_date.to_s(:db),
        :post_content => render_to_string(:layout => false)
      })

      flash[:success] = "Successfully created attendance thread for #{@live_raid.started_at.to_date.to_s(:db)}."
      respond_to do |wants|
        wants.html { redirect_to live_raids_path }
      end
    else
      respond_to do |wants|
        wants.html { redirect_to live_raid_path(@live_raid) }
      end
    end
  end

  private
    def find_raid
      @live_raid = LiveRaid.find(params[:id])
    end
end
