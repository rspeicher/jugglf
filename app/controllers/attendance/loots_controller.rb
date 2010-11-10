class Attendance::LootsController < ApplicationController
  before_filter :require_admin

  before_filter :find_parent, :only => [:update, :destroy]

  skip_before_filter :verify_authenticity_token, :only => [:update]

  def update
    begin
      @loots = LiveLoot.from_text(params[:live_loot][:input_text])

      LiveLoot.transaction do
        @loots.each do |loot|
          @parent.loots << loot
        end
        @parent.save!
      end
    rescue RuntimeError, ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => e
      if e.respond_to? :record
        flash[:error] = "At least one loot entry was invalid. (#{e.record.errors.full_messages.join(', ')})"
      else
        flash[:error] = "At least one loot entry was invalid. (#{e.message})"
      end
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
