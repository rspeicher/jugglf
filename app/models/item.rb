class Item < ActiveRecord::Base
  belongs_to :member
  belongs_to :raid
end
