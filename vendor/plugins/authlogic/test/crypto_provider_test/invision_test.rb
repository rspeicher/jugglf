require File.dirname(__FILE__) + '/../test_helper.rb'

module CryptoProviderTest
  class InvisionTest < ActiveSupport::TestCase
    def test_encrypt
      assert Authlogic::CryptoProviders::InvisionPowerBoard.encrypt("mypass")
    end
    
    def test_matches
      hash = Authlogic::CryptoProviders::InvisionPowerBoard.encrypt("mypass")
      assert Authlogic::CryptoProviders::InvisionPowerBoard.matches?(hash, "mypass")
    end
    
    def test_filtered_characters
      pass = '?&amp;!&><"!\''
      hash = Authlogic::CryptoProviders::InvisionPowerBoard.encrypt(pass)
      assert Authlogic::CryptoProviders::InvisionPowerBoard.matches?(hash, pass)
    end
  end
end