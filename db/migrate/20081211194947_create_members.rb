class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.boolean :active
      t.date :first_raid
      t.date :last_raid
      t.integer :raid_count
      t.string :wow_class
      t.float :lf
      t.float :sitlf
      t.float :bislf
      t.float :attendance_30
      t.float :attendance_90
      t.float :attendance_lifetime

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
