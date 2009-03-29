class RenameItemStatItemIdToWowId < ActiveRecord::Migration
  def self.up
    rename_column :item_stats, :item_id, :wow_id
  end

  def self.down
    rename_column :item_stats, :wow_id, :item_id
  end
end