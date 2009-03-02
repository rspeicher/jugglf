class Wishlist < ActiveRecord::Base
  PRIORITIES = ['normal','best in slot','situational','rot']
  
  # Relationships -------------------------------------------------------------
  belongs_to :item
  belongs_to :member
  
  # Attributes ----------------------------------------------------------------
  attr_accessible :item_name, :priority, :note, :member_id
  
  # Validations ---------------------------------------------------------------
  validates_inclusion_of :priority, :in => PRIORITIES, :message => "{{value}} is not a valid entry type", :allow_nil => true
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  
  # Instance Methods ----------------------------------------------------------
  def item_name
    self.item.name unless self.item_id.nil?
  end
  def item_name=(value)
    item = Item.find_or_create_by_name(value)
    self.item = item unless item.nil?
  end
  
  private
    def validate
      errors.add(:item_name, 'is invalid') if self.item_id.nil? or self.item.name.empty?
    end
end
