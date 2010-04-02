class CreateLiveRaids < ActiveRecord::Migration
  def self.up
    create_table :live_raids do |t|
      t.datetime :started_at
      t.datetime :stopped_at
      t.integer :live_attendees_count, :default => 0, :null => false
      t.integer :live_loots_count, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :live_raids
  end
end
