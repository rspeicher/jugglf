class Wishlist < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  belongs_to :item
  belongs_to :member
  
  # Attributes ----------------------------------------------------------------
  
  # Validations ---------------------------------------------------------------
  validates_format_of :priority, :with => /^(normal|best in slot|situational|rot)/, :allow_nil => true
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  
  # Instance Methods ----------------------------------------------------------
  def item_name
    self.item.name unless self.item_id.nil?
  end
  def item_name=(value)
    item = Item.find_by_name(value)
    self.item = item unless item.nil?
  end
  
  private
    def validate
      errors.add(:item_name, 'Item is required') if self.item_id.nil? or self.item.name.empty?
    end
end
