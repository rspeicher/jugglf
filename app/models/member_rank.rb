# == Schema Information
# Schema version: 20090224005026
#
# Table name: member_ranks
#
#  id     :integer(4)      not null, primary key
#  name   :string(255)
#  prefix :string(255)
#  suffix :string(255)
#

class MemberRank < ActiveRecord::Base
  SANITIZE_CONFIG = {
    :elements   => [ 'span', 'img', 'b', 'i' ],
    :attributes => {
      'span' => [ 'class', 'style' ],
      'img'  => [ 'src', 'alt', 'width', 'height', 'class' ],
      'b'    => [],
      'i'    => [],
    }
  }
  
  # Relationships -------------------------------------------------------------
  has_one :member
  
  # Validations ---------------------------------------------------------------
  validates_presence_of :name
  
  # This method became necessary because calling Sanitize on a string with no
  # closing tag automatically closed it
  def format(inner_html)
    require 'sanitize'
    
    Sanitize.clean("#{self.prefix}#{inner_html}#{self.suffix}", SANITIZE_CONFIG)
  end
end
