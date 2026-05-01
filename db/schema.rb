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

ActiveRecord::Schema[8.1].define(version: 2026_05_01_170307) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "agegroups", force: :cascade do |t|
    t.boolean "active"
    t.integer "average_age"
    t.string "category"
    t.datetime "created_at", null: false
    t.string "gender"
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_agegroups_on_category"
    t.index ["gender"], name: "index_agegroups_on_gender"
    t.index ["name"], name: "index_agegroups_on_name", unique: true
    t.index ["position"], name: "index_agegroups_on_position"
  end

  create_table "runs", force: :cascade do |t|
    t.decimal "agegrade", precision: 5, scale: 2
    t.string "agegroup"
    t.datetime "created_at", null: false
    t.date "date"
    t.string "gender"
    t.string "name"
    t.integer "position"
    t.integer "runs"
    t.integer "time"
    t.datetime "updated_at", null: false
    t.string "venue"
    t.index ["agegrade"], name: "index_runs_on_agegrade"
    t.index ["agegroup"], name: "index_runs_on_agegroup"
    t.index ["date"], name: "index_runs_on_date"
    t.index ["gender"], name: "index_runs_on_gender"
    t.index ["name"], name: "index_runs_on_name"
    t.index ["position"], name: "index_runs_on_position"
    t.index ["runs"], name: "index_runs_on_runs"
    t.index ["time"], name: "index_runs_on_time"
    t.index ["venue", "time", "date"], name: "index_runs_on_venue_and_time_and_date"
    t.index ["venue"], name: "index_runs_on_venue"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stored_stats", force: :cascade do |t|
    t.float "avg_age"
    t.integer "count"
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.integer "fastest"
    t.float "mean"
    t.float "median"
    t.integer "slowest"
    t.float "stddev"
    t.datetime "updated_at", null: false
    t.string "venue", null: false
    t.index ["date", "venue"], name: "index_stored_stats_on_date_and_venue", unique: true
    t.index ["date"], name: "index_stored_stats_on_date"
    t.index ["venue"], name: "index_stored_stats_on_venue"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "address"
    t.string "closest_city"
    t.string "code_name", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "postcode"
    t.string "region"
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false
    t.index ["active"], name: "index_venues_on_active"
    t.index ["closest_city"], name: "index_venues_on_closest_city"
    t.index ["name"], name: "index_venues_on_name"
    t.index ["region"], name: "index_venues_on_region"
  end

  add_foreign_key "sessions", "users"

  create_view "summary_stats", materialized: true, sql_definition: <<-SQL
      SELECT date,
      count("time") AS count,
      min("time") AS fastest,
      max("time") AS slowest,
      percentile_cont((0.5)::double precision) WITHIN GROUP (ORDER BY (("time")::double precision)) AS median,
      avg("time") AS mean,
      stddev("time") AS stddev,
      avg(
          CASE
              WHEN ((agegroup)::text ~ '\\d+-\\d+'::text) THEN (((("substring"((agegroup)::text, '\\d+'::text))::integer + ("substring"((agegroup)::text, '-(\\d+)'::text))::integer))::numeric / 2.0)
              WHEN ((agegroup)::text ~ '\\d+'::text) THEN (("substring"((agegroup)::text, '\\d+'::text))::integer)::numeric
              ELSE NULL::numeric
          END) AS avg_age
     FROM runs
    GROUP BY date;
  SQL
end
