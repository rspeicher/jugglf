class LootTable < ActiveRecord::Base
  belongs_to :boss, :polymorphic => true
  belongs_to :zone, :polymorphic => true
  belongs_to :item, :polymorphic => true
  
  acts_as_tree
end
