class AddCacheCounters < ActiveRecord::Migration
  def self.up
    add_column :raids, :attendees_count, :integer, :default => 0
  end

  def self.down
    remove_column :raids, :attendees_count
  end
end
