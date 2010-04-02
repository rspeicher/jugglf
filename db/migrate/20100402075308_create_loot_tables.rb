class CreateLootTables < ActiveRecord::Migration
  def self.up
    # Zones
    create_table :zones do |t|
      t.string :name, :null => false
    end

    add_index :zones, :name

    # Bosses
    create_table :bosses do |t|
      t.string :name, :null => false
    end

    add_index :bosses, :name

    # Loot Tables
    create_table :loot_tables do |t|
      t.references :object, :polymorphic => true
      t.references :parent
      t.string :note
    end

    add_index :loot_tables, :object_id
    add_index :loot_tables, :parent_id
  end

  def self.down
    drop_table :loot_tables
    drop_table :bosses
    drop_table :zones
  end
end
