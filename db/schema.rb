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

ActiveRecord::Schema.define(version: 20150911010521) do

  create_table "attachments", force: :cascade do |t|
    t.string   "slug",              limit: 255, null: false
    t.integer  "page_id",           limit: 4
    t.integer  "user_id",           limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "data_file_name",    limit: 255
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.datetime "data_updated_at"
  end

  add_index "attachments", ["page_id"], name: "index_attachments_on_page_id", using: :btree
  add_index "attachments", ["user_id"], name: "index_attachments_on_user_id", using: :btree

  create_table "collaborations", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "page_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "collaborations", ["page_id"], name: "index_collaborations_on_page_id", using: :btree
  add_index "collaborations", ["user_id"], name: "index_collaborations_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.string   "uid",        limit: 255,   null: false
    t.string   "provider",   limit: 255,   null: false
    t.text     "raw",        limit: 65535, null: false
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "identities", ["uid", "provider"], name: "index_identities_on_uid_and_provider", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title",      limit: 255,                     null: false
    t.text     "content",    limit: 16777215
    t.string   "slug",       limit: 255,                     null: false
    t.string   "ancestry",   limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "secret",                      default: true, null: false
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", unique: true, using: :btree
  add_index "pages", ["user_id"], name: "index_pages_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "nickname",   limit: 255,   null: false
    t.text     "image",      limit: 65535, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,        null: false
    t.integer  "item_id",    limit: 4,          null: false
    t.string   "event",      limit: 255,        null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "attachments", "pages"
  add_foreign_key "attachments", "users"
  add_foreign_key "collaborations", "pages"
  add_foreign_key "collaborations", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "pages", "users"
end
