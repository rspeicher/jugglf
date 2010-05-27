class LootTable < ActiveRecord::Base
  acts_as_tree

  attr_accessible :object, :object_id, :parent_id, :note

  belongs_to :object, :polymorphic => true
  alias_method :zone, :object
  alias_method :boss, :object
  alias_method :item, :object

  def to_s
    self.object.name
  end
end
