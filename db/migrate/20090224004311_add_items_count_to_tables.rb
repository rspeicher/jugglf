class AddItemsCountToTables < ActiveRecord::Migration
  def self.up
    add_column :members, :items_count, :integer, :default => 0
    add_column :raids, :items_count, :integer, :default => 0

    Raid.reset_column_information
    Raid.all.each do |raid|
      raid.update_attendee_cache = false
      raid.update_attribute :items_count, raid.items.length
    end

    Member.reset_column_information
    Member.all.each do |member|
      member.update_attribute :items_count, member.items.length
    end
  end

  def self.down
    remove_column :raids, :items_count
    remove_column :members, :items_count
  end
end
