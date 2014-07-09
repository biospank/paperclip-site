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

ActiveRecord::Schema.define(version: 20140709161646) do

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.integer  "newsletter", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "name",       null: false
    t.string   "tax_code",   null: false
    t.string   "address",    null: false
    t.integer  "cap"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers_services", force: true do |t|
    t.integer "customer_id", null: false
    t.integer "service_id",  null: false
  end

  add_index "customers_services", ["customer_id"], name: "CS_CUSTOMER_FK_IDX"
  add_index "customers_services", ["service_id"], name: "CS_SERVVICE_FK_IDX"

  create_table "downloads", force: true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.datetime "created_at"
  end

  create_table "invoice_lines", force: true do |t|
    t.integer "invoice_id",  null: false
    t.string  "description", null: false
    t.decimal "amount",      null: false
    t.integer "vat_id",      null: false
  end

  add_index "invoice_lines", ["invoice_id"], name: "INVOICE_FK_IDX"
  add_index "invoice_lines", ["vat_id"], name: "VAT_FK_IDX"

  create_table "invoice_serials", force: true do |t|
    t.integer "serial", null: false
    t.integer "year",   null: false
  end

  create_table "invoices", force: true do |t|
    t.integer  "customer_id",     null: false
    t.integer  "subscription_id", null: false
    t.integer  "number",          null: false
    t.date     "date",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["customer_id"], name: "CUSTOMER_FK_IDX"
  add_index "invoices", ["subscription_id"], name: "SUBSCRIPTION_FK_IDX"

  create_table "payment_notifications", force: true do |t|
    t.integer  "subscription_id"
    t.text     "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: true do |t|
    t.string   "service_id", null: false
    t.string   "name"
    t.integer  "months"
    t.decimal  "price"
    t.decimal  "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["service_id"], name: "PLAN_SERVICE_FK_IDX"

  create_table "services", force: true do |t|
    t.string "name", null: false
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id",               null: false
    t.integer  "plan_id",               null: false
    t.string   "email",                 null: false
    t.string   "key"
    t.string   "info"
    t.string   "paypal_payment_token"
    t.string   "paypal_customer_token"
    t.decimal  "amount"
    t.date     "expiry_date"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vats", force: true do |t|
    t.string  "description",                       null: false
    t.decimal "percentage",                        null: false
    t.integer "predefined",  limit: 1, default: 0
    t.integer "active",      limit: 1, default: 1
  end

end
