class UniqueItemIndex < ActiveRecord::Migration
  def self.up
    add_index :items, [:name, :wow_id], :unique => true
    remove_index :items, :column => :wow_id
  end

  def self.down
    add_index :items, :wow_id, :unique => true
    remove_index :items, :column => [:name, :wow_id]
  end
end
