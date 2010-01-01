class CreateLiveAttendees < ActiveRecord::Migration
  #  id               :integer(4)      not null, primary key
  #  member_name      :string(255)
  #  live_raid_id     :integer(4)
  #  started_at       :datetime
  #  stopped_at       :datetime
  #  active           :boolean(1)      default(TRUE)
  #  minutes_attended :integer(4)      default(0)
  #
  def self.up
    create_table :live_attendees do |t|
      t.string :member_name, :null => false
      t.references :live_raid
      t.datetime :started_at
      t.datetime :stopped_at
      t.boolean :active, :default => true
      t.integer :minutes_attended, :default => 0
    end
    
    add_index :live_attendees, :live_raid_id
  end

  def self.down
    drop_table :live_attendees
  end
end
