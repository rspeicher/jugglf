require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ApplicationHelper

describe ApplicationHelper do
  describe "breadcrumb" do
    it "should join with a specific string" do
      breadcrumb('A', 'B', 'C').should match(/&raquo;/)
    end
  end
  
  describe "link_to_tab" do
    it "should figure out nil path based on text" do
      link_to_tab('Text (123)').should match(/href=.+\#text/)
    end
  end
  
  describe "link_to_delete" do
    it "should return nil if no path is given" do
      link_to_delete().should be_nil
    end
    
    it "should take a custom text message" do
      link_to_delete(:path => '/', :text => 'CUSTOM TEXT').should match(/CUSTOM TEXT/)
    end
    
    it "should take a custom confirmation message" do
      link_to_delete(:path => '/', :confirm => 'Really?!').should match(/Really\?\!/)
    end
  end
  
  describe "progress_bar" do
    it "should take a custom container width" do
      progress_bar(100, :container_width => '15%').should match(/width: 15%/)
    end
    
    it "should take a custom color code" do
      progress_bar(15, :color => '#000').should match(/background-color: \#000/)
    end
  end
end
