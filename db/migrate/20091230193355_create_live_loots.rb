class CreateLiveLoots < ActiveRecord::Migration
  def self.up
    create_table :live_loots do |t|
      t.integer :wow_id
      t.string :item_name
      t.string :member_name
      t.string :loot_type
    end
  end

  def self.down
    drop_table :live_loots
  end
end
