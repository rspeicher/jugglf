class Wishlist < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_one :item
  belongs_to :member
  
  # Attributes ----------------------------------------------------------------
  
  # Validations ---------------------------------------------------------------
  validates_format_of :priority, :with => /^(normal|best in slot|situational|rot)/, :allow_nil => true
  
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  
  # Instance Methods ----------------------------------------------------------
end
