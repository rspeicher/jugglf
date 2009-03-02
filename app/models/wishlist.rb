class Wishlist < ActiveRecord::Base
  PRIORITIES = ['best in slot','normal','situational','rot']
  
  # Relationships -------------------------------------------------------------
  belongs_to :item
  belongs_to :member
  
  # Attributes ----------------------------------------------------------------
  attr_accessible :item_name, :priority, :note, :member_id
  
  # Validations ---------------------------------------------------------------
  validates_inclusion_of :priority, :in => PRIORITIES, :message => "{{value}} is not a valid entry type"
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  
  # Instance Methods ----------------------------------------------------------
  def item_name
    self.item.name unless self.item_id.nil?
  end
  def item_name=(value)
    # Legacy support for setting the wishlist's note via the item name by
    # putting it in brackets
    # FIXME: Because the :note parameter comes after :item_name, its value overwrites the one we assign here
    # Don't know how to fix that just yet.
    if self.note.nil? or self.note.empty?
      value.scan(/(.+) \[(.+)\]/) do |item_name, note|
        value     = item_name
        self.note = note
      end
    end
    
    item = Item.find_or_create_by_name(value)
    self.item = item unless item.nil?
  end
  
  private
    def validate
      errors.add(:item_name, 'is invalid') if self.item_id.nil? or self.item.name.empty?
    end
end
