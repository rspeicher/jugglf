class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees do |t|
      t.references :member
      t.references :raid
      t.float :attendance
    end
    
    add_index :attendees, [:member_id, :raid_id], :unique => true
  end

  def self.down
    remove_index :attendees, :column => [:member_id, :raid_id]
    drop_table :attendees
  end
end
