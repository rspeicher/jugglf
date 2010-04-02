class CreateAchievements < ActiveRecord::Migration
  def self.up
    # Achievements ------------------------------------------------------------
    create_table :achievements do |t|
      t.integer :armory_id, :null => false
      t.integer :category_id, :null => false
      t.string :title
      t.string :icon
    end

    add_index :achievements, [:armory_id], :unique => true
    add_index :achievements, :category_id

    # Completed Achievements --------------------------------------------------
    create_table :completed_achievements do |t|
      t.references :achievement
      t.references :member
      t.date :completed_on
    end

    add_index :completed_achievements, [:achievement_id, :member_id], :unique => true
    add_index :completed_achievements, :achievement_id
    add_index :completed_achievements, :member_id
  end

  def self.down
    drop_table :completed_achievements
    drop_table :achievements
  end
end
