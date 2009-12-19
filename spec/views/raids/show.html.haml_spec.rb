require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/raids/show.html.haml" do
  before(:each) do
    @raid = Raid.make
    
    assigns[:raid]      = @raid
    assigns[:attendees] = []
    assigns[:loots]     = []
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/raids/show.html.haml'
    end
  end

  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/raids/show.html.haml'
    end
  end
end