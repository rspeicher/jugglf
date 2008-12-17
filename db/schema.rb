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

ActiveRecord::Schema.define(:version => 20081217001941) do

  create_table "attendees", :force => true do |t|
    t.integer "member_id"
    t.integer "raid_id"
    t.float   "attendance"
  end

  add_index "attendees", ["member_id", "raid_id"], :name => "index_attendees_on_member_id_and_raid_id", :unique => true

  create_table "items", :force => true do |t|
    t.string   "name"
    t.float    "price",        :default => 0.0
    t.boolean  "situational",  :default => false
    t.boolean  "best_in_slot", :default => false
    t.integer  "member_id"
    t.integer  "raid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["member_id"], :name => "index_items_on_member_id"
  add_index "items", ["raid_id"], :name => "index_items_on_raid_id"

  create_table "members", :force => true do |t|
    t.string   "name"
    t.boolean  "active",              :default => true
    t.date     "first_raid"
    t.date     "last_raid"
    t.integer  "raid_count",          :default => 0
    t.string   "wow_class"
    t.float    "lf",                  :default => 0.0
    t.float    "sitlf",               :default => 0.0
    t.float    "bislf",               :default => 0.0
    t.float    "attendance_30",       :default => 0.0
    t.float    "attendance_90",       :default => 0.0
    t.float    "attendance_lifetime", :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["name"], :name => "index_members_on_name", :unique => true

  create_table "raids", :force => true do |t|
    t.date     "date"
    t.string   "note"
    t.integer  "thread"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
