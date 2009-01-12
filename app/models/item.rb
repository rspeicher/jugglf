# == Schema Information
# Schema version: 20081217001941
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  price        :float           default(0.0)
#  situational  :boolean(1)
#  best_in_slot :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Item < ActiveRecord::Base
  belongs_to :member
  belongs_to :raid
end
