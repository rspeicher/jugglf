class DropBossZonePosition < ActiveRecord::Migration
  def self.up
    remove_column :bosses, :position
    remove_column :zones, :position
  end

  def self.down
    add_column :zones, :position, :integer, :default => 0
    add_column :bosses, :position, :integer, :default => 0
  end
end
