# == Schema Information
# Schema version: 20090312150316
#
# Table name: ibf_members
#
#  id                      :integer(3)      default(0), not null, primary key
#  name                    :string(255)     default(""), not null
#  mgroup                  :integer(2)      default(0), not null
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
#  new_msg                 :integer(1)      default(0)
#  msg_total               :integer(2)      default(0)
#  show_popup              :boolean(1)
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
#  members_markers         :text
#  members_editor_choice   :string(3)       default("std"), not null
#  members_auto_dst        :boolean(1)      default(TRUE), not null
#  members_display_name    :string(255)     default(""), not null
#  members_created_remote  :boolean(1)      not null
#  members_cache           :text(16777215)
#  members_disable_pm      :integer(4)      default(0), not null
#  members_profile_views   :integer(4)      default(0), not null
#  members_l_display_name  :string(255)     default("0"), not null
#  members_l_username      :string(255)     default("0"), not null
#  failed_logins           :text
#  failed_login_count      :integer(2)      default(0), not null
#  has_gallery             :integer(4)      default(0)
#  persistence_token       :string(255)     default(""), not null
#  last_request_at         :datetime
#  current_login_at        :datetime
#  last_login_at           :datetime
#  current_login_ip        :string(255)
#  last_login_ip           :string(255)
#

class InvisionUser < ActiveRecord::Base
  set_table_name "ibf_members"
  
  ADMIN_GROUP     = 4
  MEMBER_GROUP    = 8
  APPLICANT_GROUP = 9

  # Authlogic -----------------------------------------------------------------
  attr_accessible :login, :password, :password_confirmation
  acts_as_authentic do |c|
    c.crypto_provider          = Authlogic::CryptoProviders::InvisionPowerBoard
    c.login_field              = :name
    c.crypted_password_field   = :converge_password
    c.password_salt_field      = :converge_salt
    # c.validate_fields          = false
    c.validate_password_field  = false
  end
  
  def converge_password
    self.converge.converge_pass_hash
  end
  def converge_salt
    self.converge.converge_pass_salt
  end
  
  def is_admin?
    self.mgroup == ADMIN_GROUP
  end
  
  # ---------------------------------------------------------------------------
  # Override some AR methods; we don't want to mess with Invision's integrity
  def destroy; end
  def delete; end
  def self.destroy_all; end
  def self.delete_all; end
  
  # Relationships -------------------------------------------------------------
  has_one :converge, :class_name => "InvisionUserConverge", :foreign_key => "converge_id"
  has_one :member, :foreign_key => "user_id"
  
  named_scope :juggernaut, :order => 'name', :conditions => ['mgroup IN (?,?,?)', ADMIN_GROUP, MEMBER_GROUP, APPLICANT_GROUP]
end
