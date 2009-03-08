class AddUserIdToMember < ActiveRecord::Migration
  def self.up
    add_column :ibf_members, :member_id, :integer
    add_index :ibf_members, :member_id
  end

  def self.down
    remove_index :ibf_members, :member_id
    remove_column :ibf_members, :member_id
  end
end
