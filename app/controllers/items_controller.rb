class ItemsController < ApplicationController
  layout 'poison'
  
  def index
    @items = Item.find(:all, :order => "created_at DESC")
    
    respond_to do |wants|
      wants.html
    end
  end
end
