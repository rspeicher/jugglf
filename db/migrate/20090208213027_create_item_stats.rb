class CreateItemStats < ActiveRecord::Migration
  def self.up
    create_table :item_stats do |t|
      t.integer :item_id
      t.string :item
      t.string :locale, :limit => 10, :default => 'en'
      t.string :color, :limit => 15
      t.string :icon
      t.integer :level, :limit => 5, :default => 0
      t.string :slot
      t.timestamps
    end
    
    add_index :item_stats, :item_id, :unique => true
  end

  def self.down
    remove_index :item_stats, :column => :item_id
    drop_table :item_stats
  end
end
