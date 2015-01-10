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

ActiveRecord::Schema.define(version: 20150107163352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.integer  "location_id"
    t.text     "street_1"
    t.text     "city"
    t.text     "state"
    t.text     "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code", null: false
    t.string   "street_2"
  end

  add_index "addresses", ["location_id"], name: "index_addresses_on_location_id", using: :btree

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "name",                   default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_admin",            default: false
  end

  add_index "admins", ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true, using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "api_applications", force: true do |t|
    t.integer  "user_id"
    t.text     "name"
    t.text     "main_url"
    t.text     "callback_url"
    t.text     "api_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_applications", ["api_token"], name: "index_api_applications_on_api_token", unique: true, using: :btree
  add_index "api_applications", ["user_id"], name: "index_api_applications_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.text     "name"
    t.text     "taxonomy_id"
    t.text     "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "tid"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "categories_services", id: false, force: true do |t|
    t.integer "category_id", null: false
    t.integer "service_id",  null: false
  end

  add_index "categories_services", ["category_id", "service_id"], name: "index_categories_services_on_category_id_and_service_id", unique: true, using: :btree
  add_index "categories_services", ["service_id", "category_id"], name: "index_categories_services_on_service_id_and_category_id", unique: true, using: :btree

  create_table "contacts", force: true do |t|
    t.integer  "location_id"
    t.text     "name"
    t.text     "title"
    t.text     "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "department"
    t.integer  "organization_id"
    t.integer  "service_id"
  end

  add_index "contacts", ["location_id"], name: "index_contacts_on_location_id", using: :btree
  add_index "contacts", ["organization_id"], name: "index_contacts_on_organization_id", using: :btree
  add_index "contacts", ["service_id"], name: "index_contacts_on_service_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "holiday_schedules", force: true do |t|
    t.integer "location_id"
    t.integer "service_id"
    t.boolean "closed",      null: false
    t.date    "start_date",  null: false
    t.date    "end_date",    null: false
    t.time    "opens_at"
    t.time    "closes_at"
  end

  add_index "holiday_schedules", ["location_id"], name: "index_holiday_schedules_on_location_id", using: :btree
  add_index "holiday_schedules", ["service_id"], name: "index_holiday_schedules_on_service_id", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "organization_id"
    t.text     "accessibility"
    t.text     "admin_emails"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "languages",       default: [],    array: true
    t.text     "name"
    t.text     "short_desc"
    t.text     "transportation"
    t.text     "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.tsvector "tsv_body"
    t.string   "alternate_name"
    t.boolean  "virtual",         default: false
    t.boolean  "active",          default: true
    t.string   "website"
    t.string   "email"
  end

  add_index "locations", ["active"], name: "index_locations_on_active", using: :btree
  add_index "locations", ["email"], name: "locations_email_with_varchar_pattern_ops", using: :btree
  add_index "locations", ["languages"], name: "index_locations_on_languages", using: :gin
  add_index "locations", ["latitude", "longitude"], name: "index_locations_on_latitude_and_longitude", using: :btree
  add_index "locations", ["organization_id"], name: "index_locations_on_organization_id", using: :btree
  add_index "locations", ["slug"], name: "index_locations_on_slug", unique: true, using: :btree
  add_index "locations", ["tsv_body"], name: "index_locations_on_tsv_body", using: :gin
  add_index "locations", ["website"], name: "locations_website_with_varchar_pattern_ops", using: :btree

  create_table "mail_addresses", force: true do |t|
    t.integer  "location_id"
    t.text     "attention"
    t.text     "street_1"
    t.text     "city"
    t.text     "state"
    t.text     "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code", null: false
    t.string   "street_2"
  end

  add_index "mail_addresses", ["location_id"], name: "index_mail_addresses_on_location_id", using: :btree

  create_table "organizations", force: true do |t|
    t.text     "name"
    t.text     "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alternate_name"
    t.date     "date_incorporated"
    t.text     "description",                    null: false
    t.string   "email"
    t.string   "legal_status"
    t.string   "tax_id"
    t.string   "tax_status"
    t.string   "website"
    t.string   "funding_sources",   default: [],              array: true
    t.string   "accreditations",    default: [],              array: true
    t.string   "licenses",          default: [],              array: true
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "phones", force: true do |t|
    t.integer  "location_id"
    t.text     "number"
    t.text     "department"
    t.text     "extension"
    t.text     "vanity_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number_type"
    t.string   "country_prefix"
    t.integer  "contact_id"
    t.integer  "organization_id"
    t.integer  "service_id"
  end

  add_index "phones", ["contact_id"], name: "index_phones_on_contact_id", using: :btree
  add_index "phones", ["location_id"], name: "index_phones_on_location_id", using: :btree
  add_index "phones", ["organization_id"], name: "index_phones_on_organization_id", using: :btree
  add_index "phones", ["service_id"], name: "index_phones_on_service_id", using: :btree

  create_table "programs", force: true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "alternate_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "programs", ["organization_id"], name: "index_programs_on_organization_id", using: :btree

  create_table "regular_schedules", force: true do |t|
    t.integer "weekday"
    t.time    "opens_at"
    t.time    "closes_at"
    t.integer "service_id"
    t.integer "location_id"
  end

  add_index "regular_schedules", ["closes_at"], name: "index_regular_schedules_on_closes_at", using: :btree
  add_index "regular_schedules", ["location_id"], name: "index_regular_schedules_on_location_id", using: :btree
  add_index "regular_schedules", ["opens_at"], name: "index_regular_schedules_on_opens_at", using: :btree
  add_index "regular_schedules", ["service_id"], name: "index_regular_schedules_on_service_id", using: :btree
  add_index "regular_schedules", ["weekday"], name: "index_regular_schedules_on_weekday", using: :btree

  create_table "services", force: true do |t|
    t.integer  "location_id"
    t.text     "audience"
    t.text     "description",                                null: false
    t.text     "eligibility"
    t.text     "fees"
    t.text     "how_to_apply",                               null: false
    t.text     "name"
    t.text     "wait_time"
    t.text     "funding_sources"
    t.text     "service_areas"
    t.text     "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "accepted_payments",       default: [],                    array: true
    t.string   "alternate_name"
    t.string   "email"
    t.string   "languages",               default: [],                    array: true
    t.string   "required_documents",      default: [],                    array: true
    t.string   "status",                  default: "active", null: false
    t.string   "website"
    t.integer  "program_id"
    t.text     "interpretation_services"
  end

  add_index "services", ["languages"], name: "index_services_on_languages", using: :gin
  add_index "services", ["location_id"], name: "index_services_on_location_id", using: :btree
  add_index "services", ["program_id"], name: "index_services_on_program_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name",                   default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "welcome_tokens", force: true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
