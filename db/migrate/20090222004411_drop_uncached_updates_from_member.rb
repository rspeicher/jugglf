class DropUncachedUpdatesFromMember < ActiveRecord::Migration
  def self.up
    remove_column :members, :uncached_updates
  end

  def self.down
    add_column :members, :uncached_updates, :integer,    :default => 0
  end
end
