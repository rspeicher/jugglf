class AddNoteToLootTable < ActiveRecord::Migration
  def self.up
    add_column :loot_tables, :note, :string
  end

  def self.down
    remove_column :loot_tables, :note
  end
end
