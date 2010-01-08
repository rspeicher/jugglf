class WishlistsController < ApplicationController
  before_filter :require_admin, :only => [:index]
  # before_filter :require_user
  
  # before_filter :find_parent
  
  def index
    page_title('Global Wishlist View')
    
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
  
  private
    # def find_parent
    #   if params[:member_id]
    #     if current_user.is_admin?
    #       # Admins can edit anyone's wishlist
    #       @parent = @member = Member.find(params[:member_id])
    #     elsif not current_user.member.nil?
    #       # Members can only edit their own wishlist
    #       @parent = @member = current_user.member
    #     else
    #       require_admin
    #     end
    #   end
    # end
end
