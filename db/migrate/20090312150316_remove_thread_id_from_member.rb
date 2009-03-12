class RemoveThreadIdFromMember < ActiveRecord::Migration
  def self.up
    remove_column :raids, :thread
  end

  def self.down
    add_column :raids, :thread, :integer
  end
end
