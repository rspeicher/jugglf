# == Schema Information
# Schema version: 20090312150316
#
# Table name: items
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  item_stat_id    :integer(4)
#  wishlists_count :integer(4)      default(0)
#  loots_count     :integer(4)      default(0)
#

class Item < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_many :loots, :dependent => :destroy
  has_many :wishlists, :order => 'priority', :dependent => :destroy
  has_many :loot_tables, :as => :object, :dependent => :destroy
  
  belongs_to :item_stat
  
  # Attributes ----------------------------------------------------------------
  searchify :name
  
  # Validations ---------------------------------------------------------------
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  
  # Moves one item's children from one Item to another to safely handle duplicate
  # item names.
  # def self.safely_rename(args = {})
  #   return if args.length < 2
  #   return if args[:from].nil? or args[:to].nil?
  #   
  #   
  #   from = Item.find(args[:from])
  #   to   = Item.find(args[:to])
  #   
  #   from.loots.each do |loot|
  #     loot.update_attributes(:item_id => to.id)
  #   end
  #   
  #   from.delete
  #   
  #   return to
  # end
  
  # Instance Methods ----------------------------------------------------------
end
