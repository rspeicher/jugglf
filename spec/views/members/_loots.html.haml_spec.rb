require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/members/_loots.html.haml" do
  before(:each) do
    @member = Member.make
    @loot = Loot.make
    @controller.template.stub!(:will_paginate).and_return(nil)
    
    assigns[:member] = @member
    assigns[:loots] = [@loot, @loot, @loot]
  end
  
  describe "as admin" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(true)
      render '/members/_loots.html.haml'
    end
  end
  
  describe "as user" do
    before(:each) do
      @controller.template.stub!(:admin?).and_return(false)
      render '/members/_loots.html.haml'
    end
  end
end