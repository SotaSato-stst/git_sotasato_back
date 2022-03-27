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

ActiveRecord::Schema.define(version: 2022_03_27_091907) do

  create_table "benefits", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "publishing_code", null: false
    t.string "title", null: false
    t.text "url", null: false
    t.bigint "prefecture_id"
    t.bigint "city_id"
    t.text "target_detail", null: false
    t.text "price_detail", null: false
    t.text "application_detail", null: false
    t.date "end_date"
    t.boolean "for_welfare", default: false, null: false
    t.boolean "for_elderly_care", default: false, null: false
    t.boolean "for_widow", default: false, null: false
    t.boolean "for_disabled", default: false, null: false
    t.integer "age_from"
    t.integer "age_to"
    t.integer "household_income_from"
    t.integer "household_income_to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_benefits_on_city_id"
    t.index ["prefecture_id"], name: "index_benefits_on_prefecture_id"
    t.index ["publishing_code"], name: "index_benefits_on_publishing_code"
    t.index ["url"], name: "index_benefits_on_url", unique: true, length: 256
  end

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url", default: "", null: false
    t.string "url_domain", default: "", null: false
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "companies", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "prefecture_id", null: false
    t.bigint "city_id", null: false
    t.string "adress"
    t.bigint "capital"
    t.integer "total_employee"
    t.string "business_scale"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "founding_date"
    t.bigint "annual_sales"
    t.string "organization_type", default: "", null: false
    t.index ["city_id"], name: "index_companies_on_city_id"
    t.index ["prefecture_id"], name: "index_companies_on_prefecture_id"
  end

  create_table "company_business_categories", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "business_category", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id", "business_category"], name: "index_unique_company_business_categories", unique: true
    t.index ["company_id"], name: "index_company_business_categories_on_company_id"
  end

  create_table "families", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "prefecture_id", null: false
    t.bigint "city_id", null: false
    t.integer "household_income"
    t.boolean "on_welfare"
    t.boolean "on_elderly_care"
    t.boolean "has_widow"
    t.boolean "has_disabled"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_families_on_city_id"
    t.index ["prefecture_id"], name: "index_families_on_prefecture_id"
    t.index ["user_id"], name: "index_families_on_user_id", unique: true
  end

  create_table "family_members", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "family_id", null: false
    t.date "birthday", null: false
    t.string "relationship", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["family_id"], name: "index_family_members_on_family_id"
  end

  create_table "keywords", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content"], name: "index_keywords_on_content", unique: true
  end

  create_table "ministries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url", default: "", null: false
    t.string "url_domain", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_ministries_on_name", unique: true
  end

  create_table "prefectures", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url", default: "", null: false
    t.string "url_domain", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_prefectures_on_name", unique: true
  end

  create_table "searched_keywords", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "keyword_id"
    t.string "content"
    t.integer "hit_count", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["keyword_id"], name: "index_searched_keywords_on_keyword_id"
    t.index ["user_id"], name: "index_searched_keywords_on_user_id"
  end

  create_table "subsidies", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "url", null: false
    t.date "start_from"
    t.date "end_to"
    t.string "publishing_code", null: false
    t.bigint "price_max"
    t.string "support_ratio_min"
    t.string "support_ratio_max"
    t.integer "level"
    t.text "detail", null: false
    t.text "target_detail", null: false
    t.string "subsidy_category"
    t.string "supplier_type"
    t.integer "ranking_score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_employee_max"
    t.integer "total_employee_min"
    t.bigint "capital_max"
    t.bigint "capital_min"
    t.integer "years_of_establishment"
    t.bigint "annual_sales_max"
    t.bigint "annual_sales_min"
    t.string "catch_copy"
    t.index ["price_max"], name: "index_subsidies_on_price_max"
    t.index ["publishing_code"], name: "index_subsidies_on_publishing_code"
    t.index ["ranking_score"], name: "index_subsidies_on_ranking_score"
    t.index ["url"], name: "index_subsidies_on_url", unique: true, length: 256
  end

  create_table "subsidy_business_categories", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.string "business_category", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subsidy_id", "business_category"], name: "index_unique_subsidy_business_categories", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_business_categories_on_subsidy_id"
  end

  create_table "subsidy_cities", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_subsidy_cities_on_city_id"
    t.index ["subsidy_id", "city_id"], name: "index_subsidy_cities_on_subsidy_id_and_city_id", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_cities_on_subsidy_id"
  end

  create_table "subsidy_drafts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "url", null: false
    t.string "source_url_domain", null: false
    t.bigint "ministry_id"
    t.bigint "prefecture_id"
    t.bigint "city_id"
    t.string "supplier_type"
    t.boolean "archived", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "assignee_id"
    t.boolean "for_benefit", default: false
    t.index ["assignee_id"], name: "index_subsidy_drafts_on_assignee_id"
    t.index ["city_id"], name: "index_subsidy_drafts_on_city_id"
    t.index ["ministry_id"], name: "index_subsidy_drafts_on_ministry_id"
    t.index ["prefecture_id"], name: "index_subsidy_drafts_on_prefecture_id"
  end

  create_table "subsidy_keywords", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.bigint "keyword_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["keyword_id"], name: "index_subsidy_keywords_on_keyword_id"
    t.index ["subsidy_id", "keyword_id"], name: "index_subsidy_keywords_on_subsidy_id_and_keyword_id", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_keywords_on_subsidy_id"
  end

  create_table "subsidy_ministries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.bigint "ministry_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ministry_id"], name: "index_subsidy_ministries_on_ministry_id"
    t.index ["subsidy_id", "ministry_id"], name: "index_subsidy_ministries_on_subsidy_id_and_ministry_id", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_ministries_on_subsidy_id"
  end

  create_table "subsidy_organization_types", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.string "organization_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subsidy_id"], name: "index_subsidy_organization_types_on_subsidy_id"
  end

  create_table "subsidy_prefectures", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_subsidy_prefectures_on_prefecture_id"
    t.index ["subsidy_id", "prefecture_id"], name: "index_subsidy_prefectures_on_subsidy_id_and_prefecture_id", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_prefectures_on_subsidy_id"
  end

  create_table "user_companies", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_user_companies_on_company_id"
    t.index ["user_id"], name: "index_user_companies_on_user_id", unique: true
  end

  create_table "user_email_logs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email_category", null: false
    t.date "sent_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sent_date"], name: "index_user_email_logs_on_sent_date"
    t.index ["user_id"], name: "index_user_email_logs_on_user_id"
  end

  create_table "user_email_unsubscribes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email_category", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_email_unsubscribes_on_user_id"
  end

  create_table "user_favorite_subsidies", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subsidy_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subsidy_id"], name: "index_user_favorite_subsidies_on_subsidy_id"
    t.index ["user_id", "subsidy_id"], name: "index_user_favorite_subsidies_on_user_id_and_subsidy_id", unique: true
    t.index ["user_id"], name: "index_user_favorite_subsidies_on_user_id"
  end

  create_table "user_profiles", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "birthday", null: false
    t.string "gender", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "firebase_uid", null: false
    t.bigint "company_id", null: false
    t.string "email", default: "", null: false
    t.string "account_role", default: "user", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "disabled", default: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["firebase_uid"], name: "index_users_on_firebase_uid", unique: true
  end

  add_foreign_key "benefits", "cities"
  add_foreign_key "benefits", "prefectures"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "companies", "cities"
  add_foreign_key "companies", "prefectures"
  add_foreign_key "company_business_categories", "companies"
  add_foreign_key "families", "cities"
  add_foreign_key "families", "prefectures"
  add_foreign_key "families", "users"
  add_foreign_key "family_members", "families"
  add_foreign_key "searched_keywords", "users"
  add_foreign_key "subsidy_business_categories", "subsidies"
  add_foreign_key "subsidy_cities", "cities"
  add_foreign_key "subsidy_cities", "subsidies"
  add_foreign_key "subsidy_drafts", "cities"
  add_foreign_key "subsidy_drafts", "ministries"
  add_foreign_key "subsidy_drafts", "prefectures"
  add_foreign_key "subsidy_drafts", "users", column: "assignee_id"
  add_foreign_key "subsidy_keywords", "subsidies"
  add_foreign_key "subsidy_ministries", "ministries"
  add_foreign_key "subsidy_ministries", "subsidies"
  add_foreign_key "subsidy_organization_types", "subsidies"
  add_foreign_key "subsidy_prefectures", "prefectures"
  add_foreign_key "subsidy_prefectures", "subsidies"
  add_foreign_key "user_companies", "companies"
  add_foreign_key "user_companies", "users"
  add_foreign_key "user_favorite_subsidies", "subsidies"
  add_foreign_key "user_favorite_subsidies", "users"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "users", "companies"
end
