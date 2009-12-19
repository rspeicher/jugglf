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
  end

  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/items/index.html.haml'
    end
  end
end