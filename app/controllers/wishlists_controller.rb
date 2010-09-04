class WishlistsController < ApplicationController
  before_filter :require_admin

  def index
    # find_all_by_object_type('Zone', :include => [:object, {:children => :object}])
    @root = LootTable.where(:object_type => 'Zone').includes(:object, :children => :object)
    @zone = @boss = nil

    if params[:boss]
      # @items = LootTable.find(:all, :include => [:parent, {:object => {:wishlists => :member}}], :conditions => ['parent_id = ?', params[:boss]])
      table = LootTable.where(:parent_id => params[:boss]).includes(:parent)
      @items = table.all

      if @items.size > 0
        @boss  = @items[0].parent
        @zone  = @boss.parent

        # Find items looted in the last week, so we can add a note if an item
        # matching the current wishlist item was recently looted by that person
        @recent_loots = Loot.recent.where(:item_id => @items.map { |i| i.object_id })
      else
        @boss = LootTable.find(params[:boss])
        @zone = @boss.parent
      end
    else
      @items = []
    end

    respond_to do |wants|
      wants.html
    end
  end
end
