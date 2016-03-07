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

ActiveRecord::Schema.define(version: 20160307085444) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "authentications", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
  end

  add_index "authentications", ["email"], name: "index_authentications_on_email", unique: true, using: :btree
  add_index "authentications", ["reset_password_token"], name: "index_authentications_on_reset_password_token", unique: true, using: :btree

  create_table "log_voips", force: :cascade do |t|
    t.string   "id_conference", limit: 255
    t.string   "name_room",     limit: 255
    t.string   "time",          limit: 255
    t.string   "participants",  limit: 255
    t.string   "caller",        limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "usersvoip_id",  limit: 4
  end

  create_table "logs", force: :cascade do |t|
    t.string   "id_conference", limit: 255
    t.string   "name_room",     limit: 255
    t.string   "time",          limit: 255
    t.string   "participants",  limit: 255
    t.string   "caller",        limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",       limit: 4
  end

  create_table "rate_voips", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "voter_id",     limit: 4
    t.string   "voter_name",   limit: 255
    t.string   "user_name",    limit: 255
    t.string   "room_name",    limit: 255
    t.string   "rate_status",  limit: 255
    t.integer  "log_id",       limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "usersvoip_id", limit: 4
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "voter_id",    limit: 4
    t.string   "voter_name",  limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "user_name",   limit: 255
    t.string   "room_name",   limit: 255
    t.string   "rate_status", limit: 255
    t.integer  "log_id",      limit: 4
  end

  create_table "tickets", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.string   "phone_number", limit: 255, null: false
    t.string   "description",  limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone_number", limit: 255
    t.string   "email",        limit: 255
    t.string   "code",         limit: 255
    t.string   "address",      limit: 255
    t.string   "name",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "token",        limit: 255
    t.string   "latitude",     limit: 255
    t.string   "longitude",    limit: 255
    t.boolean  "available",    limit: 1
    t.string   "instance_id",  limit: 255
    t.string   "description",  limit: 255
  end

  create_table "users_voips", force: :cascade do |t|
    t.string   "phone_number", limit: 255
    t.string   "email",        limit: 255
    t.string   "code",         limit: 255
    t.string   "address",      limit: 255
    t.string   "name",         limit: 255
    t.string   "token",        limit: 255
    t.string   "latitude",     limit: 255
    t.string   "longitude",    limit: 255
    t.boolean  "available",    limit: 1
    t.string   "instance_id",  limit: 255
    t.string   "description",  limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
