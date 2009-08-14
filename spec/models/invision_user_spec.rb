require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvisionUser do
  before(:each) do
    @user = InvisionUser.make_unsaved # NOTE: AHHHHHHH. Thank you, Machinist.
    @user.converge = InvisionUserConverge.make
  end
  
  it "should provide a method to get converge_pass_hash" do
    @user.converge_password.should == @user.converge.converge_pass_hash
  end
  
  it "should provide a method to getconverge_pass_salt" do
    @user.converge_salt.should == @user.converge.converge_pass_salt
  end
  
  it "should know if a user is an admin" do
    @user.is_admin?.should be_false
  end
  
  it "should take an associated member" do
    @user = InvisionUser.make_unsaved(:member => Member.make(:name => 'Name'))
    @user.member.name.should == 'Name'
  end
end
