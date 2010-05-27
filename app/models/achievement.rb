class Achievement < ActiveRecord::Base
  attr_accessible :armory_id, :category_id, :title, :icon

  has_many :completed_achievements, :dependent => :destroy
  has_many :members, :through => :completed_achievements

  validates_presence_of :armory_id
  validates_presence_of :category_id
  validates_presence_of :title

  def to_s
    "#{self.title}"
  end
end
