class InvisionUser < ActiveRecord::Base
  set_table_name "ibf_members"
  
  ADMIN_GROUP     = 4
  MEMBER_GROUP    = 8
  APPLICANT_GROUP = 9

  # Authlogic -----------------------------------------------------------------
  attr_accessible :login, :password, :password_confirmation
  acts_as_authentic do |c|
    c.crypto_provider          = Authlogic::CryptoProviders::InvisionPowerBoard
    c.login_field              = :name
    c.crypted_password_field   = :converge_password
    c.password_salt_field      = :converge_salt
    # c.validate_fields          = false
    c.validate_password_field  = false
  end
  
  def converge_password
    self.converge.converge_pass_hash
  end
  def converge_salt
    self.converge.converge_pass_salt
  end
  
  def is_admin?
    self.mgroup == ADMIN_GROUP
  end
  
  # ---------------------------------------------------------------------------
  # Override some AR methods; we don't want to mess with Invision's integrity
  def destroy; end
  def delete; end
  def self.destroy_all; end
  def self.delete_all; end
  
  # Relationships -------------------------------------------------------------
  has_one :converge, :class_name => "InvisionUserConverge", :foreign_key => "converge_id"
  has_one :member, :foreign_key => "user_id"
  
  named_scope :juggernaut, :order => 'name', :conditions => ['mgroup IN (?,?,?)', ADMIN_GROUP, MEMBER_GROUP, APPLICANT_GROUP]
end
