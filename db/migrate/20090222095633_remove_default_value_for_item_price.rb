class RemoveDefaultValueForItemPrice < ActiveRecord::Migration
  def self.up
    change_column :items, :price, :float, :null => true, :default => nil
  end

  def self.down
    change_column :items, :price, :float, :null => false, :default => 0.00
  end
end
