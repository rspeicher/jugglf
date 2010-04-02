class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name, :null => false
      t.integer :user_id
      t.integer :rank_id
      t.boolean :active, :default => true
      t.date :first_raid
      t.date :last_raid
      t.string :wow_class
      t.float :lf, :default => 0.00, :null => false
      t.float :sitlf, :default => 0.00, :null => false
      t.float :bislf, :default => 0.00, :null => false
      t.float :attendance_30, :default => 0, :null => false
      t.float :attendance_90, :default => 0, :null => false
      t.float :attendance_lifetime, :default => 0, :null => false
      t.integer :raids_count, :default => 0, :null => false
      t.integer :loots_count, :default => 0, :null => false
      t.integer :wishlists_count, :default => 0, :null => false
      t.timestamps
    end

    add_index :members, :user_id
    add_index :members, :rank_id
    add_index :members, :active
  end

  def self.down
    drop_table :members
  end
end
