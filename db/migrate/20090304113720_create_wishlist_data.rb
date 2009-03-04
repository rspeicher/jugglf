class CreateWishlistData < ActiveRecord::Migration
  def self.up
    create_table :wishlist_zones do |t|
      t.string :name, :null => false
      t.integer :position, :default => 0
    end
    add_index :wishlist_zones, :name
    add_index :wishlist_zones, :position
    
    create_table :wishlist_bosses do |t|
      t.string :name, :null => false
      t.integer :position, :default => 0
    end
    add_index :wishlist_bosses, :name
    add_index :wishlist_bosses, :position
    
    create_table :wishlist_data do |t|
      t.references :data, :polymorphic => true
      t.integer :parent_id
    end
    add_index :wishlist_data, :data_id
    add_index :wishlist_data, :parent_id
  end

  def self.down
    drop_table :wishlist_data
    drop_table :wishlist_bosses
    drop_table :wishlist_zones
  end
end
