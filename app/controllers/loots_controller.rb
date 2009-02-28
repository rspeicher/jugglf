class LootsController < ApplicationController
  before_filter :require_admin
  
  layout @@layout
  
  def index
    @loots = Loot.paginate(:page => params[:page], :per_page => 40, 
      :include => [{:item => :item_stat}, :raid, :member], 
      :order => "purchased_on DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
end
