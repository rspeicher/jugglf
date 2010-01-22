class WishlistsController < ApplicationController
  before_filter :require_admin

  def index
    page_title('Wishlists')

    @root = LootTable.find_all_by_object_type('Zone', :include => [:object, {:children => :object}])
    @zone = @boss = nil

    if params[:boss]
      @items = LootTable.find(:all, :include => [:parent, {:object => {:wishlists => :member}}], :conditions => ['parent_id = ?', params[:boss]])

      if @items.size > 0
        @boss  = @items[0].parent
        @zone  = @boss.parent

        # Find items looted in the last week, so we can add a note if an item
        # matching the current wishlist item was recently looted by that person
        @recent_loots = Loot.find(:all, :conditions => ["item_id IN (:item_ids) AND purchased_on >= :purchased_on", {
          :purchased_on => 2.weeks.ago,
          :item_ids     => @items.map { |i| i.object_id }
        }])
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
