# == Schema Information
#
# Table name: bosses
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)     not null
#  position :integer(4)      default(0)
#

class Boss < ActiveRecord::Base
  has_many :loot_tables, :as => :object, :dependent => :destroy
end
