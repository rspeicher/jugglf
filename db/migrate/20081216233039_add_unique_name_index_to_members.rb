class AddUniqueNameIndexToMembers < ActiveRecord::Migration
  def self.up
    add_index :members, [:name], :unique => true
  end

  def self.down
    remove_index :members, :column => [:name]
  end
end
