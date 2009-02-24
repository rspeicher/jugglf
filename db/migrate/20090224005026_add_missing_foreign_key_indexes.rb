class AddMissingForeignKeyIndexes < ActiveRecord::Migration
  def self.up
    add_index :punishments, :member_id
    add_index :items, :member_id
    add_index :items, :raid_id
    add_index :members, :rank_id
  end

  def self.down
    remove_index :members, :rank_id
    remove_index :items, :raid_id
    remove_index :items, :member_id
    remove_index :punishments, :member_id
  end
end
