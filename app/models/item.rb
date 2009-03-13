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
end
