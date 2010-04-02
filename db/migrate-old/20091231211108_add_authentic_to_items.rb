class AddAuthenticToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :authentic, :boolean
    
    Item.find_each do |item|
      if item.wow_id.present? and item.name.present? and item.icon.present? and item.color.present?
        item.update_attribute(:authentic, true)
      else
        item.destroy
      end
    end
  end

  def self.down
    remove_column :items, :authentic
  end
end
