class Wishlist < ActiveRecord::Base
  PRIORITIES = ['best in slot','normal','situational','rot'].freeze

  attr_accessible :item_id, :item_name, :priority, :note

  belongs_to :item, :counter_cache => true
  belongs_to :member, :counter_cache => true

  validates_inclusion_of :priority, :in => PRIORITIES, :message => "%{value} is not a valid entry type"

  def item_name
    self.item.name unless self.item_id.nil?
  end
  def item_name=(value)
    # NOTE: Using custom find_or_create_by method here to allow the user to enter an item ID instead of a name
    if item = Item.find_or_create_by_name_or_id(value)
      self.item = item
    end
  end

  protected

  validate :validate_item
  def validate_item
    unless self.item.present? and self.item.valid?
      errors.add(:base, "Invalid item provided")
    end
  end
end
