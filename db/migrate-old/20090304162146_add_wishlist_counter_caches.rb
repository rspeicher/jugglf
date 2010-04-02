class AddWishlistCounterCaches < ActiveRecord::Migration
  def self.up
    add_column :items, :wishlists_count, :integer, :default => 0
    add_column :members, :wishlists_count, :integer, :default => 0
    add_column :items, :loots_count, :integer, :default => 0
    
    Member.all.each do |m|
      m.update_attributes(:wishlists_count => m.wishlists.length)
    end
    
    Item.all.each do |i|
      i.update_attributes(:wishlists_count => i.wishlists.length)
      i.update_attributes(:loots_count => i.loots.length)
    end
  end

  def self.down
    remove_column :items, :loots_count
    remove_column :members, :wishlists_count
    remove_column :items, :wishlists_count
  end
end
