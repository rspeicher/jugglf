require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/index.html.haml" do
  before(:each) do
    @controller.template.stub!(:will_paginate).and_return(nil)
    @item = Item.make
    
    assigns[:items] = [@item]
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/items/index.html.haml'
    end

    it "should have a context menu" do
      response.should have_tag('ul#itemContextMenu', 1)
    end
  end

  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/items/index.html.haml'
    end

    it "should not have a context menu" do
      response.should_not have_tag('ul#itemContextMenu')
    end
  end
end