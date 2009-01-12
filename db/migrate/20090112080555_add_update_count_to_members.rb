class AddUpdateCountToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :uncached_updates, :integer
  end

  def self.down
    remove_column :members, :uncached_updates
  end
end
