class CreateLiveAttendees < ActiveRecord::Migration
  def self.up
    create_table :live_attendees do |t|
      t.string :member_name, :null => false
      t.references :live_raid
      t.datetime :started_at
      t.datetime :stopped_at
      t.boolean :active, :default => false
      t.integer :minutes_attended, :default => 0
    end
    
    add_index :live_attendees, :live_raid_id
  end

  def self.down
    drop_table :live_attendees
  end
end
