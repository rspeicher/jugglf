class CreateItemStats < ActiveRecord::Migration
  def self.up
    create_table :item_stats do |t|
      t.references :item
      t.string :item
      t.string :locale, :limit => 10, :default => 'en'
      t.string :color, :limit => 15
      t.string :icon
      t.integer :level, :limit => 5, :default => 0
      t.string :slot
      t.timestamps
    end
    
    add_index :item_stats, :item_id, :unique => true
    add_index :item_stats, :item
  end

  def self.down
    drop_table :item_stats
  end
end
