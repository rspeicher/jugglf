class Zone < ActiveRecord::Base
  has_many :loot_tables, :as => :object, :dependent => :destroy

  validates_presence_of :name

  def to_s
    "#{self.name}"
  end
end
