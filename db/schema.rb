# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100707213035) do

  create_table "invoices", :force => true do |t|
    t.integer  "amount"
    t.datetime "billed_date"
    t.string   "product"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_postings", :force => true do |t|
    t.string   "reference_id"
    t.string   "title"
    t.string   "company_name"
    t.text     "short_description"
    t.text     "long_description"
    t.string   "zip"
    t.string   "job_type"
    t.string   "experience"
    t.string   "pay"
    t.text     "addl_instructions"
    t.datetime "created_at"
    t.datetime "approved_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "telecommute"
    t.integer  "user_id"
    t.datetime "start_run_date"
    t.datetime "end_date"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "user_name"
    t.string   "display_name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "remember_token"
    t.string   "activation_code"
    t.string   "state"
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "telephone"
    t.string   "company"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "company_description"
    t.integer  "credits",                   :default => 0
    t.string   "company_type"
    t.string   "web_site"
  end

end
