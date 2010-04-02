class CreateRaids < ActiveRecord::Migration
  def self.up
    create_table :raids do |t|
      t.date :date, :null => false
      t.string :note
      t.integer :attendees_count, :default => 0, :null => false
      t.integer :loots_count, :default => 0, :null => false
      t.timestamps
    end

    add_index :raids, :date
  end

  def self.down
    drop_table :raids
  end
end
