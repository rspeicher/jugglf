class CreateLiveRaids < ActiveRecord::Migration
  def self.up
    create_table :live_raids do |t|
      t.datetime :started_at
      t.datetime :stopped_at
    end
  end

  def self.down
    drop_table :live_raids
  end
end
