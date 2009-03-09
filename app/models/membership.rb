class Membership < ActiveRecord::Base
  belongs_to :member
  belongs_to :user, :class_name => "InvisionUser", :foreign_key => "user_id"
end
