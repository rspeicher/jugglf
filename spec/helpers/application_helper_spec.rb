require 'spec_helper'

describe ApplicationHelper do
  describe "#admin?" do
    it "should return false if no user is logged in" do
      stubs(:current_user).returns(nil)
      admin?.should be_false
    end

    it "should return false if the current user is not an admin" do
      stubs(:current_user).returns(mock(:is_admin? => false))
      admin?.should be_false
    end

    it "should return true if the current user is an admin" do
      stubs(:current_user).returns(mock(:is_admin? => true))
      admin?.should be_true
    end
  end

  describe "#page_title" do
    it "should append a default argument" do
      helper.page_title('My Title')
      helper.content_for(:page_title).to_s.should match(/:: Juggernaut Loot Factor/)
    end

    it "should join arguments" do
      helper.page_title 'Page 1', 'Page 2'
      helper.content_for(:page_title).to_s.should match(/Page 1 :: Page 2/)
    end
  end

  describe "#breadcrumb" do
    it "should join with a specific string" do
      helper.breadcrumb('A', 'B', 'C')
      helper.content_for?(:breadcrumb).should be_true
    end
  end

  describe "#link_to_delete" do
    it "should return nil if no path is given" do
      lambda { link_to_delete('') }.should raise_error(ArgumentError, "path is required")
    end

    it "should have sane defaults" do
      output = link_to_delete('/path-to-delete')

      output.should match(/delete\.png/)
      output.should match(/href="\/path-to-delete"/)
      output.should match(/data-confirm/)
      output.should match(/data-remote/)
    end

    it "should have an image option" do
      link_to_delete(root_url, :image => false).should_not match(/delete\.png/)
    end

    it "should have a confirm option" do
      link_to_delete(root_url, :confirm => "Really?!").should match(/data-confirm="Really\?!/)
    end
  end

  describe "#progress_bar" do
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

  describe "#link_to_login_or_logout" do
    it "should link to login when logged out" do
      stubs(:current_user).returns(true)
      link_to_login_or_logout.should match(/Sign Out/)
    end

    it "should link to logout when logged in" do
      stubs(:current_user).returns(nil)
      link_to_login_or_logout.should match(/Sign In/)
    end
  end
end
