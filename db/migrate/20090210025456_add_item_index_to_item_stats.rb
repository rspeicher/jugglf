class AddItemIndexToItemStats < ActiveRecord::Migration
  def self.up
    add_index :item_stats, :item
  end

  def self.down
    remove_index :item_stats, :item
  end
end
