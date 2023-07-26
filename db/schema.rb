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

ActiveRecord::Schema[7.0].define(version: 2023_07_26_104410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "city_id"], name: "index_bookmarks_on_user_id_and_city_id", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "accuweather_key", null: false
    t.string "country", null: false
    t.string "administrative_area", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accuweather_key"], name: "index_cities_on_accuweather_key", unique: true
    t.index ["administrative_area"], name: "index_cities_on_administrative_area"
    t.index ["country"], name: "index_cities_on_country"
    t.index ["name", "country", "administrative_area"], name: "index_cities_on_name_and_country_and_administrative_area", unique: true
    t.index ["name"], name: "index_cities_on_name"
  end

  create_table "daily_forecasts", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.timestamptz "starts_at", null: false
    t.timestamptz "ends_at", null: false
    t.timestamptz "expires_at", null: false
    t.string "temperature_unit", null: false
    t.float "min_temperature", null: false
    t.float "max_temperature", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id", "starts_at", "ends_at"], name: "index_daily_forecasts_on_city_id_and_starts_at_and_ends_at", unique: true
    t.index ["city_id"], name: "index_daily_forecasts_on_city_id"
    t.index ["ends_at"], name: "index_daily_forecasts_on_ends_at"
    t.index ["expires_at"], name: "index_daily_forecasts_on_expires_at"
    t.index ["starts_at"], name: "index_daily_forecasts_on_starts_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "bookmarks", "cities"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "daily_forecasts", "cities"
end
