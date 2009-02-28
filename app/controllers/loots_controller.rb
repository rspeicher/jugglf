class LootsController < ApplicationController
  before_filter :require_admin
  
  before_filter :find_loot, :only => [:show, :edit, :update, :destroy]
  
  layout @@layout
  
  def index
    @loots = Loot.paginate(:page => params[:page], :per_page => 40, :include => :item, :order => "purchased_on DESC")
    
    respond_to do |wants|
      wants.html
    end
  end

  private
    def find_loot
      @loot = Item.find(params[:id])
    end
end
