class LootTable < ActiveRecord::Base
  acts_as_tree
  
  # Relationships -------------------------------------------------------------
  belongs_to :object, :polymorphic => true
  alias_method :zone, :object
  alias_method :boss, :object
  alias_method :item, :object
end
