class CreateWishlistData < ActiveRecord::Migration
  def self.up
    create_table :zones do |t|
      t.string :name, :null => false
      t.integer :position, :default => 0
    end
    add_index :zones, :name
    add_index :zones, :position
    
    create_table :bosses do |t|
      t.string :name, :null => false
      t.integer :position, :default => 0
    end
    add_index :bosses, :name
    add_index :bosses, :position
    
    create_table :loot_tables do |t|
      t.references :object, :polymorphic => true
      t.integer :parent_id
    end
    add_index :loot_tables, :object_id
    add_index :loot_tables, :parent_id
  end

  def self.down
    drop_table :loot_tables
    drop_table :bosses
    drop_table :zones
  end
end
