class MemberRank < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  has_one :member

  # Validations ---------------------------------------------------------------
  validates_presence_of :name

  # This method became necessary because calling Sanitize on a string with no
  # closing tag automatically closed it
  def format(inner_html)
    "#{self.prefix}#{inner_html}#{self.suffix}"
  end

  def to_s
    "#{self.name}"
  end
end
