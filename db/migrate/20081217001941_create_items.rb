class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.float :price, :default => 0.00
      t.boolean :situational, :default => 0
      t.boolean :best_in_slot, :default => 0
      t.references :member
      t.references :raid
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
