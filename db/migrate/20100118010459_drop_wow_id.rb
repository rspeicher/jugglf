class DropWowId < ActiveRecord::Migration
  def self.up
    # Add an old_id field
    add_column :items, :old_id, :integer
    add_column :loots, :old_item_id, :integer
    add_column :wishlists, :old_item_id, :integer

    # Remove the unique Name/WoW ID index
    remove_index :items, :column => [:name, :wow_id]

    # Add temporary indexes to speed this up dramatically
    add_index :items, :old_id
    add_index :loots, :old_item_id
    add_index :wishlists, :old_item_id

    # Migrate the value of id to old_id
    puts "Populating the values of old_id"
    Item.connection.execute("UPDATE `#{Item.table_name}`     SET `old_id`      = `id`")
    Item.connection.execute("UPDATE `#{Loot.table_name}`     SET `old_item_id` = `item_id`")
    Item.connection.execute("UPDATE `#{Wishlist.table_name}` SET `old_item_id` = `item_id`")

    # Migrate the value of wow_id to ID
    puts "Populating the new ID values"
    Item.connection.execute("UPDATE `#{Item.table_name}` SET `id` = `wow_id`")
    Item.find_each do |item|
      Item.connection.execute("UPDATE `#{Loot.table_name}` SET `item_id` = #{item.wow_id} WHERE (`old_item_id` = #{item.old_id})")
      Item.connection.execute("UPDATE `#{Wishlist.table_name}` SET `item_id` = #{item.wow_id} WHERE (`old_item_id` = #{item.old_id})")
    end

    # Drop temp columns
    remove_column :items, :old_id
    remove_column :loots, :old_item_id
    remove_column :wishlists, :old_item_id
    remove_column :items, :wow_id

    puts "\nCompleted migration. Remember to drop the AUTO_INCREMENT property from Items.id"
  end

  def self.down
    raise "Can't rollback, sorry! Restore a database from before 2010-01-17"
  end
end
