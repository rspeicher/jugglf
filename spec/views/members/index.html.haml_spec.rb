require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/index.html.haml" do
  include MembersHelper
  
  before(:each) do
    @member = Member.make
    
    assigns[:members] = [@member, @member, @member]
  end
  
  describe "as admin" do
    before(:each) do
      login({}, :is_admin? => true)
      render '/members/index.html.haml'
    end
    
    it "should show loot factors" do
      response.should have_tag('th.lootfactor', 3)
      response.should have_tag('td.lootfactor', 9)
    end
  end
  
  describe "as user" do
    before(:each) do
      login({}, :is_admin? => false)
      render '/members/index.html.haml'
    end
    
    it "should not show loot factors" do
      response.should_not have_tag('th.lootfactor')
      response.should_not have_tag('td.lootfactor')
    end
  end
end