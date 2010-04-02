class AddHeroicToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :heroic, :boolean, :default => false
    
    # All 258, 272 and 277 Items are Heroic
    Item.find_each(:conditions => { :level => [258, 272, 277] }) do |item|
      item.update_attribute(:heroic, true)
    end
    
    # Certain Tier Tokens are Heroic
    Item.find_each(:conditions => { :wow_id => [52028, 52029, 52030] }) do |item|
      item.update_attribute(:heroic, true)
    end
  end

  def self.down
    remove_column :items, :heroic
  end
end
