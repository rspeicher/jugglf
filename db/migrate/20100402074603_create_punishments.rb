class CreatePunishments < ActiveRecord::Migration
  def self.up
    create_table :punishments do |t|
      t.references :member, :null => false
      t.string :reason, :null => false
      t.date :expires_on, :null => false
      t.float :value, :default => 0.00, :null => false
      t.timestamps
    end

    add_index :punishments, :member_id
  end

  def self.down
    drop_table :punishments
  end
end
