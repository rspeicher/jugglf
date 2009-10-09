# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090717234345) do

  create_table "achievements", :force => true do |t|
    t.integer "armory_id"
    t.integer "category_id"
    t.string  "title"
    t.string  "icon"
  end

  add_index "achievements", ["armory_id"], :name => "index_achievements_on_armory_id", :unique => true
  add_index "achievements", ["category_id"], :name => "index_achievements_on_category_id"
  add_index "achievements", ["title"], :name => "index_achievements_on_title"

  create_table "attendees", :force => true do |t|
    t.integer "member_id"
    t.integer "raid_id"
    t.float   "attendance"
  end

  add_index "attendees", ["member_id", "raid_id"], :name => "index_attendees_on_member_id_and_raid_id", :unique => true
  add_index "attendees", ["member_id"], :name => "index_attendees_on_member_id"
  add_index "attendees", ["raid_id"], :name => "index_attendees_on_raid_id"

  create_table "bosses", :force => true do |t|
    t.string  "name",                    :null => false
    t.integer "position", :default => 0
  end

  add_index "bosses", ["name"], :name => "index_bosses_on_name"
  add_index "bosses", ["position"], :name => "index_bosses_on_position"

  create_table "completed_achievements", :force => true do |t|
    t.integer "member_id"
    t.integer "achievement_id"
    t.date    "completed_on"
  end

  add_index "completed_achievements", ["achievement_id"], :name => "index_completed_achievements_on_achievement_id"
  add_index "completed_achievements", ["member_id", "achievement_id"], :name => "index_completed_achievements_on_member_id_and_achievement_id", :unique => true
  add_index "completed_achievements", ["member_id"], :name => "index_completed_achievements_on_member_id"

  create_table "ibf_members", :force => true do |t|
    t.string   "name",                                        :default => "",      :null => false
    t.integer  "mgroup",                  :limit => 2,        :default => 0,       :null => false
    t.string   "email",                   :limit => 150,      :default => "",      :null => false
    t.integer  "joined",                                      :default => 0,       :null => false
    t.string   "ip_address",              :limit => 16,       :default => "",      :null => false
    t.integer  "posts",                   :limit => 3,        :default => 0
    t.string   "title",                   :limit => 64
    t.boolean  "allow_admin_mails"
    t.string   "time_offset",             :limit => 10
    t.string   "hide_email",              :limit => 8
    t.boolean  "email_pm"
    t.boolean  "email_full"
    t.integer  "skin",                    :limit => 2
    t.integer  "warn_level"
    t.integer  "warn_lastwarn",                               :default => 0,       :null => false
    t.string   "language",                :limit => 32
    t.integer  "last_post"
    t.string   "restrict_post",           :limit => 100,      :default => "0",     :null => false
    t.boolean  "view_sigs",                                   :default => true
    t.boolean  "view_img",                                    :default => true
    t.boolean  "view_avs",                                    :default => true
    t.boolean  "view_pop",                                    :default => true
    t.integer  "bday_day"
    t.integer  "bday_month"
    t.integer  "bday_year"
    t.integer  "new_msg",                 :limit => 1,        :default => 0
    t.integer  "msg_total",               :limit => 2,        :default => 0
    t.boolean  "show_popup",                                  :default => false
    t.string   "misc",                    :limit => 128
    t.integer  "last_visit",                                  :default => 0
    t.integer  "last_activity",                               :default => 0
    t.boolean  "dst_in_use",                                  :default => false
    t.string   "view_prefs",              :limit => 64,       :default => "-1&-1"
    t.boolean  "coppa_user",                                  :default => false
    t.string   "mod_posts",               :limit => 100,      :default => "0",     :null => false
    t.string   "auto_track",              :limit => 50,       :default => "0"
    t.string   "temp_ban",                :limit => 100,      :default => "0"
    t.integer  "sub_end",                                     :default => 0,       :null => false
    t.string   "login_anonymous",         :limit => 3,        :default => "0&0",   :null => false
    t.text     "ignored_users"
    t.string   "mgroup_others",                               :default => "",      :null => false
    t.string   "org_perm_id",                                 :default => "",      :null => false
    t.string   "member_login_key",        :limit => 32,       :default => "",      :null => false
    t.integer  "member_login_key_expire",                     :default => 0,       :null => false
    t.integer  "subs_pkg_chosen",         :limit => 2,        :default => 0,       :null => false
    t.boolean  "has_blog",                                    :default => false,   :null => false
    t.text     "members_markers"
    t.string   "members_editor_choice",   :limit => 3,        :default => "std",   :null => false
    t.boolean  "members_auto_dst",                            :default => true,    :null => false
    t.string   "members_display_name",                        :default => "",      :null => false
    t.boolean  "members_created_remote",                      :default => false,   :null => false
    t.text     "members_cache",           :limit => 16777215
    t.integer  "members_disable_pm",                          :default => 0,       :null => false
    t.integer  "members_profile_views",                       :default => 0,       :null => false
    t.string   "members_l_display_name",                      :default => "0",     :null => false
    t.string   "members_l_username",                          :default => "0",     :null => false
    t.text     "failed_logins"
    t.integer  "failed_login_count",      :limit => 2,        :default => 0,       :null => false
    t.integer  "has_gallery",                                 :default => 0
    t.string   "persistence_token",                                                :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "single_access_token"
  end

  add_index "ibf_members", ["bday_day"], :name => "bday_day"
  add_index "ibf_members", ["bday_month"], :name => "bday_month"
  add_index "ibf_members", ["members_l_display_name"], :name => "members_l_display_name"
  add_index "ibf_members", ["members_l_username"], :name => "members_l_username"
  add_index "ibf_members", ["mgroup"], :name => "mgroup"

  create_table "ibf_members_converge", :primary_key => "converge_id", :force => true do |t|
    t.string  "converge_email",     :limit => 250, :default => "", :null => false
    t.integer "converge_joined",                   :default => 0,  :null => false
    t.string  "converge_pass_hash", :limit => 32,  :default => "", :null => false
    t.string  "converge_pass_salt", :limit => 5,   :default => "", :null => false
  end

  add_index "ibf_members_converge", ["converge_email"], :name => "converge_email"

  create_table "items", :force => true do |t|
    t.string   "name",            :limit => 100
    t.integer  "wishlists_count",                :default => 0
    t.integer  "loots_count",                    :default => 0
    t.integer  "wow_id"
    t.string   "color",           :limit => 15
    t.string   "icon"
    t.integer  "level",                          :default => 0
    t.string   "slot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["name", "wow_id"], :name => "index_items_on_name_and_wow_id", :unique => true

  create_table "loot_tables", :force => true do |t|
    t.integer "object_id"
    t.string  "object_type"
    t.integer "parent_id"
    t.string  "note"
  end

  add_index "loot_tables", ["object_id"], :name => "index_loot_tables_on_object_id"
  add_index "loot_tables", ["parent_id"], :name => "index_loot_tables_on_parent_id"

  create_table "loots", :force => true do |t|
    t.integer  "item_id"
    t.float    "price"
    t.date     "purchased_on"
    t.boolean  "best_in_slot", :default => false
    t.boolean  "situational",  :default => false
    t.boolean  "rot",          :default => false
    t.integer  "member_id"
    t.integer  "raid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loots", ["item_id"], :name => "index_loots_on_item_id"
  add_index "loots", ["member_id"], :name => "index_loots_on_member_id"
  add_index "loots", ["purchased_on"], :name => "index_loots_on_purchased_on"
  add_index "loots", ["raid_id"], :name => "index_loots_on_raid_id"

  create_table "member_ranks", :force => true do |t|
    t.string "name"
    t.string "prefix"
    t.string "suffix"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.boolean  "active",              :default => true
    t.date     "first_raid"
    t.date     "last_raid"
    t.string   "wow_class"
    t.float    "lf",                  :default => 0.0
    t.float    "sitlf",               :default => 0.0
    t.float    "bislf",               :default => 0.0
    t.float    "attendance_30",       :default => 0.0
    t.float    "attendance_90",       :default => 0.0
    t.float    "attendance_lifetime", :default => 0.0
    t.integer  "raids_count",         :default => 0
    t.integer  "loots_count",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank_id"
    t.integer  "wishlists_count",     :default => 0
    t.integer  "user_id"
  end

  add_index "members", ["active"], :name => "index_members_on_active"
  add_index "members", ["rank_id"], :name => "index_members_on_rank_id"
  add_index "members", ["user_id"], :name => "index_members_on_user_id"

  create_table "punishments", :force => true do |t|
    t.integer  "member_id"
    t.string   "reason"
    t.date     "expires"
    t.float    "value",      :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "punishments", ["member_id"], :name => "index_punishments_on_member_id"

  create_table "raids", :force => true do |t|
    t.date     "date"
    t.string   "note"
    t.integer  "attendees_count", :default => 0
    t.integer  "loots_count",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raids", ["date"], :name => "index_raids_on_date"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "wishlists", :force => true do |t|
    t.integer  "item_id"
    t.integer  "member_id"
    t.string   "priority",   :default => "normal", :null => false
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wishlists", ["item_id"], :name => "index_wishlists_on_item_id"
  add_index "wishlists", ["member_id"], :name => "index_wishlists_on_member_id"

  create_table "zones", :force => true do |t|
    t.string  "name",                    :null => false
    t.integer "position", :default => 0
  end

  add_index "zones", ["name"], :name => "index_zones_on_name"
  add_index "zones", ["position"], :name => "index_zones_on_position"

end
