class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.integer :armory_id
      t.integer :category_id
      t.string :title
      t.string :icon
    end
    
    add_index :achievements, :armory_id, :unique => true
    add_index :achievements, :category_id
    add_index :achievements, :title
  end

  def self.down
    drop_table :achievements
  end
end
