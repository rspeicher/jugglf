require 'spec_helper'

include ApplicationHelper

describe ApplicationHelper do
  describe "admin?" do
    it "should return false if no user is logged in" do
      stub!(:current_user).and_return(nil)
      admin?.should be_false
    end
    
    it "should return false if the current user is not an admin" do
      stub!(:current_user).and_return(mock_model(User, :is_admin? => false))
      admin?.should be_false
    end
    
    it "should return true if the current user is an admin" do
      stub!(:current_user).and_return(mock_model(User, :is_admin? => true))
      admin?.should be_true
    end
  end
  
  describe "breadcrumb" do
    it "should join with a specific string" do
      breadcrumb('A', 'B', 'C').should eql(['A', 'B', 'C'])
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
  
  describe "link_to_remote_delete" do
    before(:each) do
      @object = mock_model(Member, :to_param => '1', :id => '1')
      stub!(:polymorphic_path).and_return('/custommember/1')
    end
    
    it "should return nil if no object is given" do
      link_to_remote_delete(nil).should be_nil
    end
    
    it "should take a custom url" do
      link_to_remote_delete(@object, :url => member_path(@object)).should match(/\/members\/1/)
    end
    
    it "should take a custom text message" do
      link_to_remote_delete(@object, :text => 'CustomText').should match(/CustomText/)
    end
    
    it "should take a custom confirmation message" do
      link_to_remote_delete(@object, :confirm => 'Really?!').should match(/Really\?!/)
    end
    
    it "should take a custom success string" do
      link_to_remote_delete(@object, :success => 'javascript:custom').should match(/javascript:custom/)
    end
    
    describe "without options" do
      it "should contain an image" do
        link_to_remote_delete(@object).should match(/<img .+ src=/)
      end
      
      it "should use our object's path" do
        link_to_remote_delete(@object).should match(/\/custommember\/1/)
      end
    end
  end
  
  describe "progress_bar" do
    it "should take a custom container width" do
      progress_bar(:width => 100, :container_width => '15%').should match(/width: 15%.*width: 100%/)
    end
    
    it "should take a custom color code" do
      progress_bar(:width => 15, :color => '#000').should match(/background-color: \#000/)
    end
    
    it "should multiply the width by 100 if a value less than 1 is provided" do
      progress_bar(:width => 2.00/30.00).should match(/width: 6%/)
    end
    
    it "should return a value of 100 when given a value of 1" do
      progress_bar(:width => 30.00/30.00).should match(/width: 100%/)
    end
  end
  
  describe "link_to_login_or_logout" do
    it "should link to login when logged out" do
      stub!(:current_user).and_return(true)
      link_to_login_or_logout.should match(/Sign Out/)
    end
    
    it "should link to logout when logged in" do
      def current_user; end
      link_to_login_or_logout.should match(/Sign In/)
    end
  end
end
