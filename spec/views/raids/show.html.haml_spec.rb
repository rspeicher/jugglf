require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/raids/show.html.haml" do
  before(:each) do
    @raid = Raid.make
    5.times { @raid.attendees.make }
    5.times { @raid.loots.make }
    
    assigns[:raid]      = @raid
    assigns[:attendees] = @raid.attendees
    assigns[:loots]     = @raid.loots
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/raids/show.html.haml'
    end

    it "should have a loot context menu" do
      response.should have_tag('ul#lootContextMenu', 1)
    end
  end

  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/raids/show.html.haml'
    end

    it "should not have a loot context menu" do
      response.should_not have_tag('ul#lootContextMenu')
    end
  end
end