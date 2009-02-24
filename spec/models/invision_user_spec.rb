require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvisionUser do
  before(:each) do
    @user = InvisionUser.make
  end
  
  it "should be valid" do
    @user.should be_valid
  end
  
  it "should authorize" do
    @user.auth?('admin').should be_true
  end
  
  it "should authorize with weird characters in the password" do
    password = "a<!--d-->min<script><><>\"\n\r!'&?!&$#(*%$()"
    
    @user.converge.converge_pass_hash = InvisionUser.generate_hash(password, 
      @user.converge.converge_pass_salt)
    
    @user.auth?(password).should be_true
  end
  
  it "should not authorize with an incorrect password" do
    @user.auth?('bad password').should be_false
  end
end
