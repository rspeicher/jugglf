class Loot < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  belongs_to :member, :counter_cache => true
  alias_method :buyer, :member
  belongs_to :raid, :counter_cache => true
  belongs_to :item, :counter_cache => true
  
  # Attributes ----------------------------------------------------------------
  
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
