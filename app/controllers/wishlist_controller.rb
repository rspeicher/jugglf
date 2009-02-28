class WishlistController < ApplicationController
  before_filter :require_user
  
  before_filter :find_parent
  
  def new
    @wishlist = Wishlist.new
    
    respond_to do |wants|
      wants.html
    end
  end
  
  private
    def find_parent
      if params[:member_id]
        @parent = @member = Member.find(params[:member_id])
      end
    end
end
