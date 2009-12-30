# == Schema Information
#
# Table name: ibf_members
#
#  member_id               :integer(3)      not null, primary key
#  name                    :string(255)     default(""), not null
#  member_group_id         :integer(2)      default(0), not null
#  email                   :string(150)     default(""), not null
#  joined                  :integer(4)      default(0), not null
#  ip_address              :string(16)      default(""), not null
#  posts                   :integer(3)      default(0)
#  title                   :string(64)
#  allow_admin_mails       :boolean(1)
#  time_offset             :string(10)
#  hide_email              :string(8)
#  email_pm                :boolean(1)
#  email_full              :boolean(1)
#  skin                    :integer(2)
#  warn_level              :integer(4)
#  warn_lastwarn           :integer(4)      default(0), not null
#  language                :string(32)
#  last_post               :integer(4)
#  restrict_post           :string(100)     default("0"), not null
#  view_sigs               :boolean(1)      default(TRUE)
#  view_img                :boolean(1)      default(TRUE)
#  view_avs                :boolean(1)      default(TRUE)
#  view_pop                :boolean(1)      default(TRUE)
#  bday_day                :integer(4)
#  bday_month              :integer(4)
#  bday_year               :integer(4)
#  msg_count_new           :integer(4)      default(0), not null
#  msg_count_total         :integer(4)      default(0), not null
#  msg_count_reset         :integer(4)      default(0), not null
#  msg_show_notification   :integer(4)      default(0), not null
#  misc                    :string(128)
#  last_visit              :integer(4)      default(0)
#  last_activity           :integer(4)      default(0)
#  dst_in_use              :boolean(1)
#  view_prefs              :string(64)      default("-1&-1")
#  coppa_user              :boolean(1)
#  mod_posts               :string(100)     default("0"), not null
#  auto_track              :string(50)      default("0")
#  temp_ban                :string(100)     default("0")
#  sub_end                 :integer(4)      default(0), not null
#  login_anonymous         :string(3)       default("0&0"), not null
#  ignored_users           :text
#  mgroup_others           :string(255)     default(""), not null
#  org_perm_id             :string(255)     default(""), not null
#  member_login_key        :string(32)      default(""), not null
#  member_login_key_expire :integer(4)      default(0), not null
#  subs_pkg_chosen         :integer(2)      default(0), not null
#  has_blog                :boolean(1)      not null
#  members_editor_choice   :string(3)       default("std"), not null
#  members_auto_dst        :boolean(1)      default(TRUE), not null
#  members_display_name    :string(255)     default(""), not null
#  members_seo_name        :string(255)     default(""), not null
#  members_created_remote  :boolean(1)      not null
#  members_cache           :text(16777215)
#  members_disable_pm      :integer(4)      default(0), not null
#  members_profile_views   :integer(4)      default(0), not null
#  members_l_display_name  :string(255)     default("0"), not null
#  members_l_username      :string(255)     default("0"), not null
#  failed_logins           :text
#  failed_login_count      :integer(2)      default(0), not null
#  has_gallery             :integer(4)      default(0)
#  persistence_token       :string(255)     not null
#  last_request_at         :datetime
#  current_login_at        :datetime
#  last_login_at           :datetime
#  current_login_ip        :string(255)
#  last_login_ip           :string(255)
#  single_access_token     :string(255)
#  members_pass_hash       :string(32)      default(""), not null
#  members_pass_salt       :string(5)       default(""), not null
#  member_banned           :boolean(1)      not null
#  identity_url            :text
#  member_uploader         :string(32)      default("default"), not null
#  members_bitoptions      :integer(4)      default(0), not null
#  fb_uid                  :integer(4)      default(0), not null
#  fb_emailhash            :string(60)      default(""), not null
#  fb_emailallow           :integer(4)      default(0), not null
#  fb_lastsync             :integer(4)      default(0), not null
#  members_day_posts       :string(32)      default("0,0"), not null
#  live_id                 :string(32)
#

class User < InvisionBridge::User::Base
  ADMIN_GROUP     = 4
  MEMBER_GROUP    = 8
  APPLICANT_GROUP = 9

  named_scope :juggernaut, :order => 'name', :conditions => { :member_group_id => [ADMIN_GROUP, MEMBER_GROUP, APPLICANT_GROUP] }
  has_one :member, :foreign_key => "user_id"

  def is_admin?
    self.member_group_id == ADMIN_GROUP
  end
end
