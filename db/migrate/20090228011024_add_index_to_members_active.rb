class AddIndexToMembersActive < ActiveRecord::Migration
  def self.up
    add_index :members, :active
  end

  def self.down
    remove_index :members, :active
  end
end
