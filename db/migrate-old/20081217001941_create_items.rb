class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name, :limit => 100
      t.references :item_stat
    end
    
    add_index :items, :name, :unique => true
    add_index :items, :item_stat_id
  end

  def self.down
    drop_table :items
  end
end
