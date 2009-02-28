# == Schema Information
# Schema version: 20090225185730
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  price        :float
#  situational  :boolean(1)
#  best_in_slot :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  rot          :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @item = Item.make
  end
  
  it "should be valid" do
    @item.should be_valid
  end
end
