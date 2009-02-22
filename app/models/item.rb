# == Schema Information
# Schema version: 20090213233547
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
#  rot          :boolean(1)
#

class Item < ActiveRecord::Base
  # Relationships -------------------------------------------------------------
  # NOTE: counter_cache with non-has_many :through assocations and the << operator is FUCKING BUGGY AS SHIT
  # See https://gist.github.com/862e344f8ec10995de66
  belongs_to :member#, :counter_cache => true
  belongs_to :raid#, :counter_cache => true
  alias_method :buyer, :member
  
  # Instance Methods ----------------------------------------------------------
  def affects_loot_factor?
    self.raid.date >= 8.weeks.until(Date.today) if self.raid
  end
  
  def adjusted_price
    ( self.rot? ) ? 0.50 : self.price
  end
end
