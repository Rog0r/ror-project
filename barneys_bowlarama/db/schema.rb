# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121016235947) do

  create_table "alley_reservations", :force => true do |t|
    t.integer  "alley_id"
    t.integer  "reservation_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "alley_reservations", ["alley_id"], :name => "index_alley_reservations_on_alley_id"
  add_index "alley_reservations", ["reservation_id"], :name => "index_alley_reservations_on_reservation_id"

  create_table "alleys", :force => true do |t|
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "alleys_reservations", :force => true do |t|
    t.integer "alley_id",       :null => false
    t.integer "reservation_id", :null => false
  end

  create_table "holidays", :force => true do |t|
    t.date     "date"
    t.string   "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "office_hours", :force => true do |t|
    t.string   "day"
    t.time     "open_from"
    t.time     "open_to"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reservations", :force => true do |t|
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reservations", ["user_id"], :name => "index_reservations_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",               :default => ""
    t.string   "encrypted_password",  :default => ""
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role",                                :null => false
    t.string   "first_name",                          :null => false
    t.string   "last_name",                           :null => false
    t.string   "phone",                               :null => false
    t.integer  "bonus_count",         :default => 0
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
