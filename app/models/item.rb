# == Schema Information
# Schema version: 20090225185730
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  price        :float
#  situational  :boolean(1)
#  best_in_slot :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  rot          :boolean(1)
#

class Item < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_many :loots, :dependent => :destroy
  has_many :wishlists, :dependent => :destroy
  has_many :loot_tables, :as => :loot_table, :dependent => :destroy
  
  belongs_to :item_stat
end
