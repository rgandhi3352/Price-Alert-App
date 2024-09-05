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

ActiveRecord::Schema[7.0].define(version: 2024_09_05_165324) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "status", default: 0
    t.integer "coin", default: 0
    t.float "target_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alert_type"
    t.index ["alert_type"], name: "index_alerts_on_alert_type"
    t.index ["status"], name: "index_alerts_on_status"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "alerts", "users"
end
