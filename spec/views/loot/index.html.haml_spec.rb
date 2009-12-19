require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/loots/index.html.haml" do
  before(:each) do
    @controller.template.stub!(:will_paginate).and_return(nil)
    @loot = Loot.make
    
    assigns[:loots] = [@loot, @loot, @loot]
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/loots/index.html.haml'
    end
  end
  
  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/loots/index.html.haml'
    end
  end
end