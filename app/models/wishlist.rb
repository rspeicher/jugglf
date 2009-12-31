# == Schema Information
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
  attr_accessible :item_id, :item_name, :wow_id, :priority, :note, :member_id
  
  def item_name
    self.item.name unless self.item_id.nil?
  end
  def item_name=(value)
    item = Item.find_by_name(value)
    self.item = item unless item.nil?
  end
  
  def wow_id
    self.item.wow_id unless self.item_id.nil?
  end
  def wow_id=(value)
    item = Item.find_by_name_or_wow_id(value)
    self.item = item unless item.nil?
  end
  
  # Validations ---------------------------------------------------------------
  validates_inclusion_of :priority, :in => PRIORITIES, :message => "{{value}} is not a valid entry type"
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  
  # Instance Methods ----------------------------------------------------------
  
  protected
    def validate
      unless self.item_id.present? and self.item.authentic?
        errors.add_to_base("Invalid item provided")
      end
    end
end
