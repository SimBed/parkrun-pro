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

ActiveRecord::Schema[8.1].define(version: 2026_03_17_103436) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "parkruns", force: :cascade do |t|
    t.string "code_name", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false
    t.index ["name"], name: "index_parkruns_on_name"
  end

  create_table "runs", force: :cascade do |t|
    t.decimal "agegrade", precision: 5, scale: 2
    t.string "agegroup"
    t.datetime "created_at", null: false
    t.date "date"
    t.string "gender"
    t.string "name"
    t.string "parkrun"
    t.integer "position"
    t.integer "runs"
    t.integer "time"
    t.datetime "updated_at", null: false
    t.index ["agegrade"], name: "index_runs_on_agegrade"
    t.index ["agegroup"], name: "index_runs_on_agegroup"
    t.index ["date"], name: "index_runs_on_date"
    t.index ["gender"], name: "index_runs_on_gender"
    t.index ["name"], name: "index_runs_on_name"
    t.index ["parkrun", "time", "date"], name: "index_runs_on_parkrun_and_time_and_date"
    t.index ["parkrun"], name: "index_runs_on_parkrun"
    t.index ["position"], name: "index_runs_on_position"
    t.index ["runs"], name: "index_runs_on_runs"
    t.index ["time"], name: "index_runs_on_time"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
