class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees do |t|
      t.integer :member_id
      t.integer :raid_id
      t.float :attendance
    end
    
    add_index :attendees, [:member_id, :raid_id], :unique => true
  end

  def self.down
    remove_index :attendees, :column => [:member_id, :raid_id]
    drop_table :attendees
  end
end
