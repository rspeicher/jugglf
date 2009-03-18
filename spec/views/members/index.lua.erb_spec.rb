require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/index.lua.erb" do
  before(:each) do
    @member = Member.make
    
    assigns[:members] = [@member, @member, @member]
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/members/index.lua.erb'
    end
    
    it "should show data" do
      response.body.should match(/JuggyCompare_Data/)
    end
  end
  
  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/members/index.lua.erb'
    end
    
    it "should not show data" do
      response.body.should_not match(/JuggyCompare_Data/)
    end
  end
end