class AddIsAdminFlagToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_admin, :bool, :null => false, :default => false
  end

  def self.down
    remove_column :users, :is_admin
  end
end
