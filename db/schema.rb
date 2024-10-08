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

ActiveRecord::Schema[7.1].define(version: 2024_08_22_035045) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "level", default: 0
    t.string "color", default: "bg-white"
    t.integer "position", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "data_conversions", force: :cascade do |t|
    t.integer "version", default: 0
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", force: :cascade do |t|
    t.integer "duration", null: false
    t.string "schedule", null: false
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_goals_on_category_id"
    t.index ["user_id", "category_id"], name: "index_goals_on_user_id_and_category_id", unique: true
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "periods", force: :cascade do |t|
    t.datetime "start", precision: 0
    t.datetime "end", precision: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.bigint "user_id", null: false
    t.index ["category_id"], name: "index_periods_on_category_id"
    t.index ["user_id"], name: "index_periods_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.string "unique_identifier", null: false
    t.string "pass", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_reports_on_category_id"
    t.index ["unique_identifier"], name: "index_reports_on_unique_identifier", unique: true
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "subscription_type", null: false
    t.boolean "email", default: false
    t.boolean "telegram", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "subscription_type"], name: "index_subscriptions_on_user_id_and_subscription_type", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone"
    t.string "locale", default: "en"
    t.boolean "admin", default: false
    t.integer "telegram_id"
    t.string "telegram_username"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "goals", "categories"
  add_foreign_key "goals", "users"
  add_foreign_key "periods", "users"
  add_foreign_key "reports", "categories"
  add_foreign_key "reports", "users"
  add_foreign_key "subscriptions", "users"
end
