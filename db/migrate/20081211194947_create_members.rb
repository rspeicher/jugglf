class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.boolean :active, :default => true
      t.date :first_raid
      t.date :last_raid
      t.integer :raids_count, :default => 0
      t.string :wow_class, :default => ''
      t.float :lf, :default => 0.00
      t.float :sitlf, :default => 0.00
      t.float :bislf, :default => 0.00
      t.float :attendance_30, :default => 0.00
      t.float :attendance_90, :default => 0.00
      t.float :attendance_lifetime, :default => 0.00

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
