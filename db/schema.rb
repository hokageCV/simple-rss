# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_13_142155) do
  create_table "articles", force: :cascade do |t|
    t.integer "feed_id", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.datetime "published_at"
    t.integer "user_id", null: false
    t.string "status", default: "unread"
    t.text "content"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "summary", default: ""
    t.string "image_url"
    t.index ["feed_id"], name: "index_articles_on_feed_id"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "feed_folders", force: :cascade do |t|
    t.integer "feed_id", null: false
    t.integer "folder_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id", "folder_id"], name: "index_feed_folders_on_feed_id_and_folder_id", unique: true
    t.index ["feed_id"], name: "index_feed_folders_on_feed_id"
    t.index ["folder_id"], name: "index_feed_folders_on_folder_id"
    t.index ["user_id"], name: "index_feed_folders_on_user_id"
  end

  create_table "feeds", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_paused", default: false, null: false
    t.string "generator", default: "", null: false
    t.index ["user_id", "url"], name: "index_feeds_on_user_id_and_url", unique: true
    t.index ["user_id"], name: "index_feeds_on_user_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "api_key"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "articles", "feeds", on_delete: :cascade
  add_foreign_key "articles", "users", on_delete: :cascade
  add_foreign_key "feed_folders", "feeds"
  add_foreign_key "feed_folders", "folders"
  add_foreign_key "feed_folders", "users"
  add_foreign_key "feeds", "users"
  add_foreign_key "folders", "users"
  add_foreign_key "sessions", "users"
end
