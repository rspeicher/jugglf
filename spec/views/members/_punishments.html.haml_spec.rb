require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/_punishments.html.haml" do
  before(:each) do
    @member = Member.make
    @punishment = Punishment.make
    
    assigns[:member] = @member
    assigns[:punishments] = [@punishment, @punishment, @punishment]
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/members/_punishments.html.haml'
    end
    
    it "should show admin actions" do
      response.should have_tag('th.image', 1)
      response.should have_tag('td.image', 3)
    end
    
    it "should show 'Add Punishment' button" do
      response.should have_tag('div.buttons', 1)
    end
  end
  
  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/members/_punishments.html.haml'
    end
    
    it "should not show admin actions" do
      response.should_not have_tag('th.image')
      response.should_not have_tag('td.image')
    end
    
    it "should not show 'Add Punishment' button" do
      response.should_not have_tag('div.buttons')
    end
  end
end