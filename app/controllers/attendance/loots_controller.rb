class Attendance::LootsController < ApplicationController
  before_filter :require_admin

  def edit
    @loots = LiveLoot.find(:all, :include => [:item, :member], :order => "id DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def update
    @loots = LiveLoot.from_text(params[:live_loot][:input_text])
    
    LiveLoot.transaction do
      @loots.each(&:save!)
      
      respond_to do |wants|
        wants.html { redirect_to edit_live_loot_path(1) } # TODO: What ID do we want to use?
        wants.js
      end
    end
    rescue RuntimeError, ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => e
      flash[:error] = "At least one loot entry was invalid. (#{e.message})"
      respond_to do |wants|
        wants.html { render :action => "edit" }
        wants.js
      end
  end
end
