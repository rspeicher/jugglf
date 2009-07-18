# == Schema Information
# Schema version: 20090717234345
#
# Table name: bosses
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)     default(""), not null
#  position :integer(4)      default(0)
#

class Boss < ActiveRecord::Base
  has_many :loot_tables, :as => :object, :dependent => :destroy
  
  acts_as_list
end
