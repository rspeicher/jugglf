class Attendance::LootsController < ApplicationController
  before_filter :require_admin
  
  before_filter :find_parent, :only => [:update, :destroy]

  def update
    @loots = LiveLoot.from_text(params[:live_loot][:input_text])
    
    LiveLoot.transaction do
      @loots.each do |loot|
        @parent.loots << loot
      end
      @parent.save
    
      respond_to do |wants|
        wants.js
      end
    end
    rescue RuntimeError, ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => e
      flash[:error] = "At least one loot entry was invalid. (#{e.message})"
      respond_to do |wants|
        wants.js
      end
  end
  
  def destroy
    @live_loot = @parent.loots.find(params[:id])
    @live_loot.destroy
    
    respond_to do |wants|
      wants.html { redirect_to(live_raid_path(@parent)) }
      wants.js { head :ok }
    end
  end
  
  private
    def find_parent
      @parent = @live_raid = LiveRaid.find(params[:live_raid_id])
    end
end
