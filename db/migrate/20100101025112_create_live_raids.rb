class CreateLiveRaids < ActiveRecord::Migration
  def self.up
    create_table :live_raids do |t|
      t.datetime :started_at
      t.datetime :stopped_at
      t.integer :live_attendees_count, :default => 0
      t.integer :live_loots_count, :default => 0
    end
    
    add_column :live_loots, :live_raid_id, :integer
    add_index :live_loots, :live_raid_id
  end

  def self.down
    remove_index :live_loots, :live_raid_id
    remove_column :live_loots, :live_raid_id
    drop_table :live_raids
  end
end
