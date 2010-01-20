module Members::WishlistsHelper
  def group_wishlist_notes(wishlists)
    retval = {}
    return retval if wishlists.blank?
    
    wishlists.each do |wishlist|
      retval[wishlist.item_id] ||= []
      retval[wishlist.item_id] << {:priority => wishlist.priority, :note => wishlist.note}
    end
    
    retval
  end
end
