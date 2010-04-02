class AddSingleAccessTokenToInvisionUser < ActiveRecord::Migration
  def self.up
    add_column :ibf_members, :single_access_token, :string, :null => true
    
    InvisionUser.find_each do |user|
      user.update_attributes(:single_access_token => nil)
    end
  end

  def self.down
    remove_column :ibf_members, :single_access_token
  end
end
