module InvisionBridge
  class InvisionUser < ActiveRecord::Base
    include ActiveRecord::Acts::InvisionBridge

    establish_bridge('members')

    # Authlogic -----------------------------------------------------------------
    attr_accessible :login, :password, :password_confirmation
    acts_as_authentic do |c|
      c.crypto_provider          = Authlogic::CryptoProviders::InvisionPowerBoard
      c.login_field              = :name
      c.crypted_password_field   = :members_pass_hash
      c.password_salt_field      = :members_pass_salt
      # c.validate_fields          = false
      c.validate_password_field  = false
    end

    # ---------------------------------------------------------------------------
    # Override some AR methods; we don't want to mess with Invision's integrity
    def destroy; end
    def delete; end
    def self.destroy_all; end
    def self.delete_all; end
    
    # Juggernaut-only stuff ----------------------------------------------------
    # TODO: Remove this stuff and only do it in Juggernaut-related apps
    
    ADMIN_GROUP     = 4
    MEMBER_GROUP    = 8
    APPLICANT_GROUP = 9
    
    named_scope :juggernaut, :order => 'name', :conditions => { :member_group_id => [ADMIN_GROUP, MEMBER_GROUP, APPLICANT_GROUP] }
    has_one :member, :foreign_key => "user_id"
    
    def is_admin?
      self.member_group_id == ADMIN_GROUP
    end
  end
end