require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/raids/index.html.haml" do
  before(:each) do
    @controller.template.stub!(:will_paginate).and_return(nil)
    @raid = Raid.make
    
    assigns[:raids] = [@raid]
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/raids/index.html.haml'
    end

    it "should have a context menu" do
      response.should have_tag('ul#contextMenu', 1)
    end
  end

  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/raids/index.html.haml'
    end

    it "should not have a context menu" do
      response.should_not have_tag('ul#contextMenu')
    end
  end
end