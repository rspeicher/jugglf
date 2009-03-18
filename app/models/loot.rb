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
  attr_accessor :update_cache
  
  attr_accessible(:item, :item_name, :price, :purchased_on, :best_in_slot, 
    :situational, :rot, :member, :member_id, :member_name, :raid_id, :update_cache)
  
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
  validates_numericality_of :price, :allow_nil => true
  
  # Callbacks -----------------------------------------------------------------
  before_save [:set_purchased_on]
  after_save [:update_buyer_cache]
  
  # Class Methods -------------------------------------------------------------
  
  # Instance Methods ----------------------------------------------------------
  def affects_loot_factor?
    self.purchased_on >= 52.days.until(Date.today)
  end
  
  def adjusted_price
    ( self.rot? ) ? 0.50 : self.price
  end
  
  private
    def set_purchased_on
      if self.purchased_on.nil? and not self.raid_id.nil?
        self.purchased_on = self.raid.date
      end
    end
    
    def update_buyer_cache
      self.member.update_cache unless @update_cache == false or self.member_id.nil?
    end
end