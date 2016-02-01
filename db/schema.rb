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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160201073431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "authentications", ["email"], name: "index_authentications_on_email", unique: true, using: :btree
  add_index "authentications", ["reset_password_token"], name: "index_authentications_on_reset_password_token", unique: true, using: :btree

  create_table "logs", force: :cascade do |t|
    t.string   "id_conference"
    t.string   "name_room"
    t.string   "time"
    t.string   "participants"
    t.string   "caller"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "point"
    t.integer  "voter_id"
    t.string   "voter_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_name"
    t.string   "room_name"
  end

  create_table "tickets", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "phone_number", null: false
    t.string   "description",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "email"
    t.string   "code"
    t.string   "address"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "token"
    t.string   "latitude"
    t.string   "longitude"
    t.boolean  "available"
    t.string   "instance_id"
    t.string   "description"
  end

end
