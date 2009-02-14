class CreatePunishments < ActiveRecord::Migration
  def self.up
    create_table :punishments do |t|
      t.references :member
      t.string :reason
      t.date :expires
      t.float :value, :default => 0.00, :precision => 10, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :punishments
  end
end
