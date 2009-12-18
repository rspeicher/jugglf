require 'spec_helper'

describe Authlogic::CryptoProviders::InvisionPowerBoard do
  it "should encrypt" do
    Authlogic::CryptoProviders::InvisionPowerBoard.encrypt("mypass").should be_true
  end
  
  it "should match expected output" do
    hash = Authlogic::CryptoProviders::InvisionPowerBoard.encrypt("mypass")
    Authlogic::CryptoProviders::InvisionPowerBoard.matches?(hash, "mypass").should be_true
  end
  
  it "should filter characters" do
    pass = '?&amp;!&><"!\''
    hash = Authlogic::CryptoProviders::InvisionPowerBoard.encrypt(pass)
    Authlogic::CryptoProviders::InvisionPowerBoard.matches?(hash, pass).should be_true
  end
end