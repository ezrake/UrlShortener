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

ActiveRecord::Schema[7.0].define(version: 2022_05_13_132018) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "click_stats", force: :cascade do |t|
    t.string "user_agent"
    t.integer "clicks"
    t.bigint "url_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url_id"], name: "index_click_stats_on_url_id"
  end

  create_table "urls", force: :cascade do |t|
    t.string "long_url"
    t.string "short_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_url"
    t.datetime "expires_at"
  end

  add_foreign_key "click_stats", "urls"
end
