# == Schema Information
# Schema version: 20090717234345
#
# Table name: wishlists
#
#  id         :integer(4)      not null, primary key
#  item_id    :integer(4)
#  member_id  :integer(4)
#  priority   :string(255)     default("normal"), not null
#  note       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Wishlist < ActiveRecord::Base
  PRIORITIES = ['best in slot','normal','situational','rot']
  
  # Relationships -------------------------------------------------------------
  belongs_to :item, :counter_cache => true
  belongs_to :member, :counter_cache => true
  
  # Attributes ----------------------------------------------------------------
  attr_accessible :item_id, :item_name, :priority, :note, :member_id
  
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
    
    # NOTE: Using custom find_or_create_by method here to allow the user to enter an item ID instead of a name
    item = Item.find_or_create_by_name_or_wow_id(value)
    self.item = item unless item.nil?
  end
  
  # Validations ---------------------------------------------------------------
  validates_inclusion_of :priority, :in => PRIORITIES, :message => "{{value}} is not a valid entry type"
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  
  # Instance Methods ----------------------------------------------------------
  
  private
    def validate
      errors.add(:item_name, 'is invalid') if self.item_id.nil? or self.item.name.empty?
    end
end
