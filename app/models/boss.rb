class Boss < ActiveRecord::Base
  attr_accessible :name

  has_many :loot_tables, :as => :object, :dependent => :destroy

  validates_presence_of :name

  def to_s
    "#{self.name}"
  end
end
