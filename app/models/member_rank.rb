# == Schema Information
#
# Table name: member_ranks
#
#  id     :integer(4)      not null, primary key
#  name   :string(255)
#  prefix :string(255)
#  suffix :string(255)
#

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
end
