require 'spec_helper'

describe ItemsHelper do
  describe "#link_to_wowhead" do
    before do
      @item = Factory(:item_with_real_stats)
      Item.stubs(:lookup).returns(@item)
    end

    it "should return nil for nil item" do
      link_to_wowhead(nil).should eql(nil)
    end

    it "should link to wowhead" do
      link_to_wowhead(@item).should match(/wowhead.com\/\?item=40395/)
    end

    it "should include the quality class" do
      link_to_wowhead(@item).should match(/class='q4'/)
    end

    it "should include the item name" do
      link_to_wowhead(@item).should match(/Torch of Holy Fire/)
    end

    it "should use existing item record if available" do
      @item.expects(:lookup).never
      link_to_wowhead(@item).should match(/Torch of Holy Fire/)
    end
  end

  describe "#link_to_item_with_stats" do
    before do
      @item = Factory(:item_with_real_stats)

      Item.stubs(:lookup).returns(@item)
    end

    it "should return nil for nil item" do
      link_to_item_with_stats(nil).should eql(nil)
    end

    it "should include the item path" do
      link_to_item_with_stats(@item).should match(/href='\/items\/40395-torch-of-holy-fire'/)
    end

    it "should include a relative item link for tooltips" do
      link_to_item_with_stats(@item).should match(/rel='item=40395/)
    end

    it "should include the quality class" do
      link_to_item_with_stats(@item).should match(/class='q4'/)
    end

    it "should include the item name" do
      link_to_item_with_stats(@item).should match(/Torch of Holy Fire/)
    end

    it "should use existing item record if available" do
      @item.expects(:lookup).never
      link_to_item_with_stats(@item).should match(/Torch of Holy Fire/)
    end
  end

  describe "#wowhead_item_icon" do
    it "should return a Wowhead icon link" do
      wowhead_item_icon('INV_Icon_01', 'medium').should eql("http://static.wowhead.com/images/wow/icons/medium/inv_icon_01.jpg")
      wowhead_item_icon('inv_icon_01', :large).should eql("http://static.wowhead.com/images/wow/icons/large/inv_icon_01.jpg")
    end

    it "should return an empty string if the icon does not exist" do
      wowhead_item_icon(nil, :large).should eql('')
    end
  end
end
