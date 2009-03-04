class Boss < ActiveRecord::Base
  has_many :loot_tables, :as => :loot_table
  
  acts_as_list
end
