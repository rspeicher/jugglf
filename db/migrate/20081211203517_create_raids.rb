class CreateRaids < ActiveRecord::Migration
  def self.up
    create_table :raids do |t|
      t.date :date
      t.string :note
      t.integer :thread
      t.timestamps
    end
  end

  def self.down
    drop_table :raids
  end
end
