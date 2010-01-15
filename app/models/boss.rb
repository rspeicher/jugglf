# == Schema Information
#
# Table name: bosses
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)     not null
#  position :integer(4)      default(0)
#

class Boss < ActiveRecord::Base
  attr_accessible :name
  
  has_many :loot_tables, :as => :object, :dependent => :destroy
  
  validates_presence_of :name
  
  def to_s
    "#{self.name}"
  end
end
