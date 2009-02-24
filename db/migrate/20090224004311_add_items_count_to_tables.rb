class AddItemsCountToTables < ActiveRecord::Migration
  def self.up
    add_column :members, :items_count, :integer, :default => 0
    add_column :raids, :items_count, :integer, :default => 0
  end

  def self.down
    remove_column :raids, :items_count
    remove_column :members, :items_count
  end
end
