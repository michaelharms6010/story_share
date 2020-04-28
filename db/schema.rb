# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_28_183937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.boolean "confirmed", default: false, null: false
    t.datetime "confirmed_at"
    t.boolean "rejected", default: false, null: false
    t.boolean "accepted", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "stories", force: :cascade do |t|
    t.integer "word_count", default: 0, null: false
    t.text "text", default: "", null: false
    t.integer "visibility", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "topic_id"
    t.index ["topic_id"], name: "index_stories_on_topic_id"
    t.index ["user_id"], name: "index_stories_on_user_id"
    t.index ["visibility"], name: "index_stories_on_visibility"
  end

  create_table "topics", force: :cascade do |t|
    t.string "prompt", default: "", null: false
    t.string "length", default: "MEDIUM", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["length"], name: "index_topics_on_length"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "name_formatted"
    t.string "email"
    t.string "password_digest"
    t.string "password_confirmation"
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean "admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "time_zone", default: "Pacific Time (US & Canada)", null: false
    t.boolean "show_full_name", default: false, null: false
    t.integer "invited_by"
    t.boolean "profile_completed", default: false, null: false
    t.integer "streak", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invited_by"], name: "index_users_on_invited_by"
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "stories", "topics"
  add_foreign_key "stories", "users"
end
