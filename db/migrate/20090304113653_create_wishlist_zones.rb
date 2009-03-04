class CreateWishlistZones < ActiveRecord::Migration
  def self.up
    create_table :wishlist_zones do |t|
    end
  end

  def self.down
    drop_table :wishlist_zones
  end
end
