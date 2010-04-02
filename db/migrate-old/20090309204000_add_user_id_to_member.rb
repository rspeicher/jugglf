class AddUserIdToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :user_id, :integer
    add_index :members, :user_id
  end

  def self.down
    remove_index :members, :user_id
    remove_column :members, :user_id
  end
end
