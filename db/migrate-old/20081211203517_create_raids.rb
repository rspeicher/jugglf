class CreateRaids < ActiveRecord::Migration
  def self.up
    create_table :raids do |t|
      t.date :date
      t.string :note
      t.integer :thread
      t.integer :attendees_count, :default => 0
      t.integer :loots_count, :default => 0
      t.timestamps
    end
    
    add_index :raids, :date
  end

  def self.down
    drop_table :raids
  end
end
