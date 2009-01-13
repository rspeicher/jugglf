class AddRotToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :rot, :boolean
  end

  def self.down
    remove_column :items, :rot
  end
end
