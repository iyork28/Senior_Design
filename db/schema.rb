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

ActiveRecord::Schema.define(version: 20140415165624) do

  create_table "charge_modifications", force: true do |t|
    t.integer  "charge_id"
    t.integer  "user_id"
    t.float    "amount"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charge_modifications", ["charge_id"], name: "index_charge_modifications_on_charge_id"
  add_index "charge_modifications", ["user_id"], name: "index_charge_modifications_on_user_id"

  create_table "charges", force: true do |t|
    t.string   "description"
    t.float    "amount"
    t.integer  "organization_id"
    t.integer  "chargeable_id"
    t.string   "chargeable_type"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charges", ["organization_id"], name: "index_charges_on_organization_id"

  create_table "groups", force: true do |t|
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "groups", ["name"], name: "index_groups_on_name", unique: true

  create_table "groups_users", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "timestamp"
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id"

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password",   default: "9d4e1e23bd5b727046a9e3b4b7db57bd8d6ee684"
  end

  create_table "organizations_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.boolean  "admin",           default: false
    t.datetime "timestamp"
  end

  add_index "organizations_users", ["user_id", "organization_id"], name: "index_organizations_users_on_user_id_and_organization_id"

  create_table "payment_plan_modifications", force: true do |t|
    t.integer  "charge_id"
    t.integer  "user_id"
    t.float    "amount"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_plan_modifications", ["charge_id"], name: "index_payment_plan_modifications_on_charge_id"
  add_index "payment_plan_modifications", ["user_id"], name: "index_payment_plan_modifications_on_user_id"

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.float    "amount"
    t.boolean  "confirmed",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_type",    default: "cash"
    t.text     "description"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
