# == Schema Information
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
#  persistence_token       :string(255)     not null
#  last_request_at         :datetime
#  current_login_at        :datetime
#  last_login_at           :datetime
#  current_login_ip        :string(255)
#  last_login_ip           :string(255)
#  single_access_token     :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvisionUser do
  before(:each) do
    @user = InvisionUser.make_unsaved # NOTE: AHHHHHHH. Thank you, Machinist.
    @user.converge = InvisionUserConverge.make
  end
  
  it "should provide a method to get converge_pass_hash" do
    @user.converge_password.should eql(@user.converge.converge_pass_hash)
  end
  
  it "should provide a method to getconverge_pass_salt" do
    @user.converge_salt.should eql(@user.converge.converge_pass_salt)
  end
  
  it "should know if a user is an admin" do
    @user.is_admin?.should be_false
  end
  
  it "should take an associated member" do
    @user = InvisionUser.make_unsaved(:member => Member.make(:name => 'Name'))
    @user.member.name.should eql('Name')
  end
end
