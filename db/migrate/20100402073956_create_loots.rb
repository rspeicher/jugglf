class CreateLoots < ActiveRecord::Migration
  def self.up
    create_table :loots do |t|
      t.references :item
      t.references :raid
      t.references :member
      t.float :price
      t.date :purchased_on
      t.boolean :best_in_slot, :default => false, :null => false
      t.boolean :situational, :default => false, :null => false
      t.boolean :rot, :default => false, :null => false
      t.timestamps
    end

    add_index :loots, :item_id
    add_index :loots, :raid_id
    add_index :loots, :member_id
    add_index :loots, :purchased_on
  end

  def self.down
    drop_table :loots
  end
end
