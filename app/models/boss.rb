class Boss < ActiveRecord::Base
  has_many :loot_tables, :as => :object, :dependent => :destroy
  
  acts_as_list
end
