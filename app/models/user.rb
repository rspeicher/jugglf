class User < InvisionBridge::UserBase
  ADMIN_GROUP     = 4
  MEMBER_GROUP    = 8
  APPLICANT_GROUP = 9

  scope :juggernaut, order(:name).where(:member_group_id => [ADMIN_GROUP, MEMBER_GROUP, APPLICANT_GROUP])
  has_one :member, :foreign_key => "user_id"

  def is_admin?
    self.member_group_id == ADMIN_GROUP
  end
end
