class AddAuthlogicFieldsToInvisionUser < ActiveRecord::Migration
  def self.up
    add_column :ibf_members, :persistence_token, :string, :null => false
    add_column :ibf_members, :login_count, :integer, :null => false, :default => 0
    add_column :ibf_members, :last_request_at, :datetime
    add_column :ibf_members, :current_login_at, :datetime
    add_column :ibf_members, :last_login_at, :datetime
    add_column :ibf_members, :current_login_ip, :string
    add_column :ibf_members, :last_login_ip, :string
  end

  def self.down
    remove_column :ibf_members, :last_login_ip
    remove_column :ibf_members, :current_login_ip
    remove_column :ibf_members, :last_login_at
    remove_column :ibf_members, :current_login_at
    remove_column :ibf_members, :last_request_at
    remove_column :ibf_members, :failed_login_count
    remove_column :ibf_members, :persistence_token
  end
end
