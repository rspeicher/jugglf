class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees do |t|
      t.references :member
      t.references :raid
      t.float :attendance
    end
    
    add_index :attendees, [:member_id, :raid_id], :unique => true
    add_index :attendees, :member_id
    add_index :attendees, :raid_id
  end

  def self.down
    drop_table :attendees
  end
end
