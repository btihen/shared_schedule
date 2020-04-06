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

ActiveRecord::Schema.define(version: 2020_02_15_214940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "event_name", null: false
    t.string "event_description"
    t.bigint "reason_id", null: false
    t.bigint "tenant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reason_id"], name: "index_events_on_reason_id"
    t.index ["tenant_id"], name: "index_events_on_tenant_id"
  end

  create_table "reasons", force: :cascade do |t|
    t.string "reason_name", null: false
    t.string "reason_description"
    t.bigint "tenant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reason_name", "tenant_id"], name: "index_reasons_on_reason_name_and_tenant_id", unique: true
    t.index ["tenant_id"], name: "index_reasons_on_tenant_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.string "host"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "start_date_time", null: false
    t.bigint "event_id", null: false
    t.bigint "space_id", null: false
    t.bigint "tenant_id", null: false
    t.bigint "start_time_slot_id", null: false
    t.bigint "end_time_slot_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["end_date"], name: "index_reservations_on_end_date"
    t.index ["end_time_slot_id"], name: "index_reservations_on_end_time_slot_id"
    t.index ["event_id", "space_id", "start_date", "end_date", "start_time_slot_id", "end_time_slot_id"], name: "index_reservation_unique", unique: true
    t.index ["event_id"], name: "index_reservations_on_event_id"
    t.index ["space_id"], name: "index_reservations_on_space_id"
    t.index ["start_date"], name: "index_reservations_on_start_date"
    t.index ["start_time_slot_id"], name: "index_reservations_on_start_time_slot_id"
    t.index ["tenant_id"], name: "index_reservations_on_tenant_id"
  end

  create_table "space_time_slots", force: :cascade do |t|
    t.bigint "space_id", null: false
    t.bigint "time_slot_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["space_id", "time_slot_id"], name: "index_space_time_slots_on_space_id_and_time_slot_id", unique: true
    t.index ["space_id"], name: "index_space_time_slots_on_space_id"
    t.index ["time_slot_id"], name: "index_space_time_slots_on_time_slot_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "space_name", null: false
    t.string "space_location"
    t.string "time_zone", default: "Europe/Zurich", null: false
    t.boolean "is_calendar_public", default: false, null: false
    t.boolean "is_double_booking_ok", default: false, null: false
    t.bigint "tenant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["space_name", "tenant_id"], name: "index_spaces_on_space_name_and_tenant_id", unique: true
    t.index ["space_name"], name: "index_spaces_on_space_name"
    t.index ["tenant_id"], name: "index_spaces_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "tenant_name", null: false
    t.string "tenant_tagline"
    t.string "tenant_site_url"
    t.string "tenant_logo_url"
    t.text "tenant_description"
    t.boolean "is_demo_tenant", default: false, null: false
    t.boolean "is_publicly_viewable", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_name"], name: "index_tenants_on_tenant_name", unique: true
  end

  create_table "time_slots", force: :cascade do |t|
    t.string "time_slot_name", null: false
    t.time "begin_time", null: false
    t.time "end_time", null: false
    t.bigint "tenant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["begin_time", "end_time", "tenant_id"], name: "index_time_slots_on_begin_time_and_end_time_and_tenant_id", unique: true
    t.index ["tenant_id"], name: "index_time_slots_on_tenant_id"
    t.index ["time_slot_name", "tenant_id"], name: "index_time_slots_on_time_slot_name_and_tenant_id", unique: true
  end

  create_table "user_interests", force: :cascade do |t|
    t.bigint "reason_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reason_id", "user_id"], name: "index_user_interests_on_reason_id_and_user_id", unique: true
    t.index ["reason_id"], name: "index_user_interests_on_reason_id"
    t.index ["user_id"], name: "index_user_interests_on_user_id"
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
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "user_title"
    t.string "user_role", default: "member", null: false
    t.bigint "tenant_id", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "events", "reasons"
  add_foreign_key "events", "tenants"
  add_foreign_key "reasons", "tenants"
  add_foreign_key "reservations", "events"
  add_foreign_key "reservations", "spaces"
  add_foreign_key "reservations", "tenants"
  add_foreign_key "reservations", "time_slots", column: "end_time_slot_id"
  add_foreign_key "reservations", "time_slots", column: "start_time_slot_id"
  add_foreign_key "space_time_slots", "spaces"
  add_foreign_key "space_time_slots", "time_slots"
  add_foreign_key "spaces", "tenants"
  add_foreign_key "time_slots", "tenants"
  add_foreign_key "user_interests", "reasons"
  add_foreign_key "user_interests", "users"
  add_foreign_key "users", "tenants"
end
