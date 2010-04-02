class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :color
      t.string :icon
      t.integer :level, :default => 0
      t.string :slot
      t.boolean :heroic, :default => false, :null => false
      t.boolean :authentic, :default => false, :null => false
      t.integer :loots_count, :default => 0, :null => false
      t.integer :wishlists_count, :default => 0, :null => false
      t.timestamps
    end

    add_index :items, :name
  end

  def self.down
    drop_table :items
  end
end
