class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.float :price, :default => 0.00
      t.boolean :situational, :default => 0
      t.boolean :best_in_slot, :default => 0
      t.integer :member_id
      t.integer :raid_id
      t.timestamps
    end
    
    add_index :items, :raid_id
    add_index :items, :member_id
  end

  def self.down
    remove_index :items, :member_id
    remove_index :items, :raid_id
    drop_table :items
  end
end
