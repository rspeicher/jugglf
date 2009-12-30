class Attendance::LootController < ApplicationController
  before_filter :require_admin

  def edit
    @loots = LiveLoot.all
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def update
    @loots = LiveLoot.from_text(params[:live_loot][:input_text])
    begin
      @loots.each(&:save!)
    rescue Exception => e
      flash[:error] = "Could not save all live loot records."
    else
      respond_to do |wants|
        wants.html { redirect_to edit_live_loot_path(1) } # TODO: What ID do we want to use?
      end
    end
  end
end
