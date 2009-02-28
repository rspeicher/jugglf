class ItemsController < ApplicationController
  # Show is really showing all of the purchases of a particular Item, so that should
  # go in that controller.
  # def show
  #   @purchases = Item.find_all_by_item_id(:include => :raid, :order => "purchased_on DESC", :conditions => ["name = ?", @loot.name])
  #   
  #   respond_to do |wants|
  #     wants.html
  #   end
  # end
end
