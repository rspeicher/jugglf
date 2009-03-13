# == Schema Information
# Schema version: 20090312150316
#
# Table name: mgdkp_wishlist
#
#  wl_id     :integer(3)      not null, primary key
#  wl_member :string(30)      default(""), not null
#  wl_item   :string(255)     default(""), not null
#  wl_type   :string(20)      default("normal"), not null
#  wl_note   :string(255)     default(""), not null
#

class LegacyWishlist < ActiveRecord::Base
  set_table_name "mgdkp_wishlist"
  set_primary_key "wl_id"
end
