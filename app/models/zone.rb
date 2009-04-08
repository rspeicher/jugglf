# == Schema Information
# Schema version: 20090404033151
#
# Table name: zones
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)     default(""), not null
#  position :integer(4)      default(0)
#

class Zone < ActiveRecord::Base
  has_many :loot_tables, :as => :object, :dependent => :destroy
  
  acts_as_list
end
