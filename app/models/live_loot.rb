# == Schema Information
#
# Table name: live_loots
#
#  id          :integer(4)      not null, primary key
#  wow_id      :integer(4)
#  item_name   :string(255)
#  member_name :string(255)
#  loot_type   :string(255)
#

class LiveLoot < ActiveRecord::Base
  attr_accessible :wow_id, :item_name, :member_name, :loot_type
  validates_presence_of :item_name
  validates_inclusion_of :loot_type, :in => %w(bis rot sit bisrot), :allow_nil => true
end
