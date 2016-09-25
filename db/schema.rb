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

ActiveRecord::Schema.define(version: 20160925214923) do

  create_table "billing_schemes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.datetime "canceled_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "billing_scheme_id"
  end

  add_index "customers", ["billing_scheme_id"], name: "index_customers_on_billing_scheme_id"

  create_table "sites", force: :cascade do |t|
    t.string   "url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "status"
  end

  add_index "sites", ["status"], name: "index_sites_on_status"
  add_index "sites", ["user_id"], name: "index_sites_on_user_id"

  create_table "usage_tiers", force: :cascade do |t|
    t.integer  "start"
    t.decimal  "price_per",         precision: 8, scale: 2
    t.integer  "billing_scheme_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "usage_tiers", ["billing_scheme_id"], name: "index_usage_tiers_on_billing_scheme_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.boolean  "admin",       default: false
    t.integer  "sites_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
  end

  add_index "users", ["customer_id"], name: "index_users_on_customer_id"

end
