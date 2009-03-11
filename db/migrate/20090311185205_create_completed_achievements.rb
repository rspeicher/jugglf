class CreateCompletedAchievements < ActiveRecord::Migration
  def self.up
    create_table :completed_achievements do |t|
      t.references :member
      t.references :achievement
      t.date :completed_on
    end
    
    add_index :completed_achievements, :member_id
    add_index :completed_achievements, :achievement_id
    add_index :completed_achievements, [:member_id, :achievement_id], :unique => true
  end

  def self.down
    drop_table :completed_achievements
  end
end
