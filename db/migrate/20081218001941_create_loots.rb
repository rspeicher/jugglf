class CreateLoots < ActiveRecord::Migration
  def self.up
    create_table :loots do |t|
      t.references :item
      t.float :price
      t.boolean :best_in_slot, :default => 0
      t.boolean :situational, :default => 0
      t.boolean :rot, :default => 0
      t.references :member
      t.references :raid
      t.timestamps
    end
    
    add_index :loots, :item_id
    add_index :loots, :member_id
    add_index :loots, :raid_id
  end

  def self.down
    remove_index :loots, :item_id
    remove_index :loots, :raid_id
    remove_index :loots, :member_id
    drop_table :drops
  end
end