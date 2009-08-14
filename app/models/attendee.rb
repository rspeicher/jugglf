class Attendee < ActiveRecord::Base
  belongs_to :member, :counter_cache => :raids_count
  belongs_to :raid, :counter_cache => true
end
