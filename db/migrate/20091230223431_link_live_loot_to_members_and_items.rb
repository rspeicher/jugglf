class LinkLiveLootToMembersAndItems < ActiveRecord::Migration
  def self.up
    add_column :live_loots, :item_id, :integer
    add_column :live_loots, :member_id, :integer
    
    add_index :live_loots, :item_id
    add_index :live_loots, :member_id
    
    remove_column :live_loots, :item_name
    remove_column :live_loots, :member_name
    remove_column :live_loots, :wow_id
  end

  def self.down
    add_column :live_loots, :wow_id, :integer
    add_column :live_loots, :member_name, :string
    add_column :live_loots, :item_name, :string
    
    remove_index :live_loots, :member_id
    remove_index :live_loots, :item_id
    
    remove_column :live_loots, :member_id
    remove_column :live_loots, :item_id
  end
end
