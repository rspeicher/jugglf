class MergeItemStatIntoItem < ActiveRecord::Migration
  def self.up
    # Add the needed columns from ItemStat into Item
    add_column :items, :wow_id, :integer
    add_column :items, :color, :string, :limit => 15
    add_column :items, :icon, :string
    add_column :items, :level, :integer, :default => 0
    add_column :items, :slot, :string
    add_column :items, :created_at, :datetime
    add_column :items, :updated_at, :datetime
    
    add_index :items, :wow_id, :unique => true
    remove_index :items, :column => :name # Remove unique item name index
    
    # Transfer data from ItemStat
    Item.find_each(:conditions => "item_stat_id IS NOT NULL") do |item|
      stat            = item.item_stat
      item.wow_id     = stat.wow_id
      item.color      = stat.color
      item.icon       = stat.icon
      item.level      = stat.level
      item.slot       = stat.slot
      item.created_at = stat.created_at
      item.save
    end
    
    remove_index :items, :column => :item_stat_id
    
    # Drop ItemStat association from Item
    remove_column :items, :item_stat_id
    drop_table :item_stats
  end

  def self.down
    create_table "item_stats", :force => true do |t|
      t.integer  "wow_id"
      t.string   "item"
      t.string   "locale",     :limit => 10, :default => "en"
      t.string   "color",      :limit => 15
      t.string   "icon"
      t.integer  "level",      :limit => 8,  :default => 0
      t.string   "slot"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_column :items, :item_stat_id, :integer
    add_index :items, :name, :unique => true
    remove_index :items, :column => :wow_id
    remove_column :items, :updated_at
    remove_column :items, :created_at
    remove_column :items, :slot
    remove_column :items, :level
    remove_column :items, :icon
    remove_column :items, :color
    remove_column :items, :wow_id
  end
end
