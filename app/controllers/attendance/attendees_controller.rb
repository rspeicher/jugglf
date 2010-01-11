class Attendance::AttendeesController < ApplicationController
  before_filter :require_admin
  
  before_filter :find_parent,   :only => [:update, :destroy]
  before_filter :find_attendee, :only => [:update, :destroy]
  
  def update
    @live_attendee.toggle!
    
    respond_to do |wants|
      wants.js
    end
  end
  
  def destroy
    @live_attendee.destroy
    
    respond_to do |wants|
      wants.html { redirect_to live_raid_path(@parent) }
      wants.js { head :ok }
    end
  end
  
  private
    def find_parent
      @parent = @live_raid = LiveRaid.find(params[:live_raid_id])
    end
    
    def find_attendee
      @live_attendee = @parent.attendees.find(params[:id])
    end
end
