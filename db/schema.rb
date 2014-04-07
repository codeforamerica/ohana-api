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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140404220233) do

  create_table "addresses", :force => true do |t|
    t.integer  "location_id"
    t.text     "street"
    t.text     "city"
    t.text     "state"
    t.text     "zip"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "addresses", ["location_id"], :name => "index_addresses_on_location_id"

  create_table "api_applications", :force => true do |t|
    t.integer  "user_id"
    t.text     "name"
    t.text     "main_url"
    t.text     "callback_url"
    t.text     "api_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "api_applications", ["api_token"], :name => "index_api_applications_on_api_token", :unique => true
  add_index "api_applications", ["user_id"], :name => "index_api_applications_on_user_id"

  create_table "categories", :force => true do |t|
    t.text     "name"
    t.text     "oe_id"
    t.text     "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ancestry"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "categories_services", :id => false, :force => true do |t|
    t.integer "category_id", :null => false
    t.integer "service_id",  :null => false
  end

  add_index "categories_services", ["category_id", "service_id"], :name => "index_categories_services_on_category_id_and_service_id", :unique => true
  add_index "categories_services", ["service_id", "category_id"], :name => "index_categories_services_on_service_id_and_category_id", :unique => true

  create_table "contacts", :force => true do |t|
    t.integer  "location_id"
    t.text     "name"
    t.text     "title"
    t.text     "email"
    t.text     "fax"
    t.text     "phone"
    t.text     "extension"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "contacts", ["location_id"], :name => "index_contacts_on_location_id"

  create_table "faxes", :force => true do |t|
    t.integer  "location_id"
    t.text     "number"
    t.text     "department"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "faxes", ["location_id"], :name => "index_faxes_on_location_id"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "locations", :force => true do |t|
    t.integer  "organization_id"
    t.text     "accessibility"
    t.text     "admin_emails"
    t.text     "description"
    t.text     "emails"
    t.text     "hours"
    t.text     "kind"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "languages"
    t.text     "name"
    t.text     "short_desc"
    t.text     "transportation"
    t.text     "urls"
    t.text     "slug"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "locations", ["latitude", "longitude"], :name => "index_locations_on_latitude_and_longitude"
  add_index "locations", ["organization_id"], :name => "index_locations_on_organization_id"
  add_index "locations", ["slug"], :name => "index_locations_on_slug", :unique => true

  create_table "mail_addresses", :force => true do |t|
    t.integer  "location_id"
    t.text     "attention"
    t.text     "street"
    t.text     "city"
    t.text     "state"
    t.text     "zip"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "mail_addresses", ["location_id"], :name => "index_mail_addresses_on_location_id"

  create_table "organizations", :force => true do |t|
    t.text     "name"
    t.text     "urls"
    t.text     "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "organizations", ["slug"], :name => "index_organizations_on_slug", :unique => true

  create_table "phones", :force => true do |t|
    t.integer  "location_id"
    t.text     "number"
    t.text     "department"
    t.text     "extension"
    t.text     "vanity_number"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "phones", ["location_id"], :name => "index_phones_on_location_id"

  create_table "services", :force => true do |t|
    t.integer  "location_id"
    t.text     "audience"
    t.text     "description"
    t.text     "eligibility"
    t.text     "fees"
    t.text     "how_to_apply"
    t.text     "name"
    t.text     "short_desc"
    t.text     "urls"
    t.text     "wait"
    t.text     "funding_sources"
    t.text     "service_areas"
    t.text     "keywords"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "services", ["location_id"], :name => "index_services_on_location_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "name",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
