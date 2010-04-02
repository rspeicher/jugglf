class CreateLiveLoots < ActiveRecord::Migration
  def self.up
    create_table :live_loots do |t|
      t.references :live_raid
      t.references :item
      t.references :member
      t.string :loot_type
    end

    add_index :live_loots, :live_raid_id
    add_index :live_loots, :item_id
    add_index :live_loots, :member_id
  end

  def self.down
    drop_table :live_loots
  end
end
