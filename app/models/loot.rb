# == Schema Information
# Schema version: 20090312150316
#
# Table name: loots
#
#  id           :integer(4)      not null, primary key
#  item_id      :integer(4)
#  price        :float
#  purchased_on :date
#  best_in_slot :boolean(1)
#  situational  :boolean(1)
#  rot          :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Loot < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  belongs_to :member, :counter_cache => true
  alias_method :buyer, :member
  belongs_to :raid, :counter_cache => true
  belongs_to :item, :counter_cache => true
  
  # Attributes ----------------------------------------------------------------
  attr_accessible :item_name, :price, :purchased_on, :best_in_slot, :situational, :rot, :member_name, :raid_id
  
  def item_name
    self.item.name unless self.item_id.nil?
  end
  def item_name=(value)
    self.item = Item.find_by_name(value)
  end
  
  def member_name
    self.member.name unless self.member_id.nil?
  end
  def member_name=(value)
    self.member = Member.find_by_name(value)
  end
  
  # Validations ---------------------------------------------------------------
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  
  # Instance Methods ----------------------------------------------------------
  def affects_loot_factor?
    self.purchased_on >= 52.days.until(Date.today)
  end
  
  def adjusted_price
    ( self.rot? ) ? 0.50 : self.price
  end
end
