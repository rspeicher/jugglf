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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LegacyWishlist do
end
