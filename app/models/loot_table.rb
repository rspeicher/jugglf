# == Schema Information
#
# Table name: loot_tables
#
#  id          :integer(4)      not null, primary key
#  object_id   :integer(4)
#  object_type :string(255)
#  parent_id   :integer(4)
#  note        :string(255)
#

class LootTable < ActiveRecord::Base
  acts_as_tree
  
  # Relationships -------------------------------------------------------------
  belongs_to :object, :polymorphic => true
  alias_method :zone, :object
  alias_method :boss, :object
  alias_method :item, :object
  
  def to_s
    self.object.name
  end
end
