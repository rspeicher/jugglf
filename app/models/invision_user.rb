class InvisionUser < ActiveRecord::Base
  set_table_name "ibf_members"
  
  # Relationships -------------------------------------------------------------
  has_one :converge, :class_name => "InvisionUserConverge", :foreign_key => "converge_id"
  
  # Attributes ----------------------------------------------------------------
  # Validations ---------------------------------------------------------------
  # Callbacks -----------------------------------------------------------------
  
  # Class Methods -------------------------------------------------------------
  def self.generate_hash(raw_password, salt)
    raw_password = self.filter(raw_password)
    
    require 'digest/md5'
    return Digest::MD5.hexdigest(Digest::MD5.hexdigest(salt) + 
      Digest::MD5.hexdigest(raw_password))
  end
  
  # Instance Methods ----------------------------------------------------------
  def auth?(raw_password)
    self.converge.converge_pass_hash == InvisionUser.generate_hash(raw_password, 
      self.converge.converge_pass_salt)
  end
  
  private
    def self.filter(input)
      # Invision's input filtering replaces a bunch of characters, some of which 
      # may be used in a strong password. We have to apply the same changes so 
      # that  the md5'd string ends up the same
      input.gsub!('&[^amp;]?', '&amp;')
      input.gsub!('<!--', '&#60;&#33;--')
      input.gsub!('-->', '--&#62;')
      input.gsub!(/<script/i, '&#60;script')
      input.gsub!('>', '&gt;')
      input.gsub!('<', '&lt;')
      input.gsub!('"', '&quot;')
      input.gsub!("\\\$", '&#036;')
      input.gsub!('!', '&#33;')
      input.gsub!("'", '&#39;')
      
      # NOTE: Invision does these, but we're not real worried about them
      # input.gsub!("\n", '<br />')
      # input.gsub!("\r", '')
      
      input
    end
end