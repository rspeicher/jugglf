require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/index.html.haml" do
  before(:each) do
    @member = Member.make
    
    assigns[:members] = [@member, @member, @member]
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/members/index.html.haml'
    end
    
    it "should show loot factors" do
      response.should have_tag('th.lootfactor', 3)
      response.should have_tag('td.lootfactor', 9)
    end
    
    it "should have a context menu" do
      response.should have_tag('ul#contextMenu')
    end
  end
  
  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/members/index.html.haml'
    end
    
    it "should not show loot factors" do
      response.should_not have_tag('th.lootfactor')
      response.should_not have_tag('td.lootfactor')
    end
    
    it "should not have a context menu" do
      response.should_not have_tag('ul#contextMenu')
    end
  end
end