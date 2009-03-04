class CreateWishlistBosses < ActiveRecord::Migration
  def self.up
    create_table :wishlist_bosses do |t|
    end
  end

  def self.down
    drop_table :wishlist_bosses
  end
end
