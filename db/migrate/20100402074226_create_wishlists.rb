class CreateWishlists < ActiveRecord::Migration
  def self.up
    create_table :wishlists do |t|
      t.references :item
      t.references :member
      t.string :priority, :null => false, :default => 'normal'
      t.string :note
      t.timestamps
    end

    add_index :wishlists, :item_id
    add_index :wishlists, :member_id
  end

  def self.down
    drop_table :wishlists
  end
end
