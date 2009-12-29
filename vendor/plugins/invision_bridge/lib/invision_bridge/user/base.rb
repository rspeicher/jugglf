module InvisionBridge
  module User
    class Base < ActiveRecord::Base
      self.abstract_class = true
      
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
    end
  end
end