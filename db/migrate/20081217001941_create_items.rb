class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
    end
    
    add_index :items, :name, :unique => true
  end

  def self.down
    remove_index :items, :column => :name
    drop_table :items
  end
end
