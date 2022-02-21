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

ActiveRecord::Schema.define(version: 2022_02_21_083745) do

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
    t.integer "capital"
    t.integer "total_employee"
    t.string "business_scale"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.date "start_from", null: false
    t.date "end_to"
    t.string "publishing_code", null: false
    t.integer "price_max"
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

  create_table "subsidy_prefectures", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_subsidy_prefectures_on_prefecture_id"
    t.index ["subsidy_id", "prefecture_id"], name: "index_subsidy_prefectures_on_subsidy_id_and_prefecture_id", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_prefectures_on_subsidy_id"
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

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "firebase_uid", null: false
    t.bigint "company_id", null: false
    t.string "email", default: "", null: false
    t.string "display_name", default: "", null: false
    t.string "account_role", default: "user", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["firebase_uid"], name: "index_users_on_firebase_uid", unique: true
  end

  add_foreign_key "cities", "prefectures"
  add_foreign_key "companies", "cities"
  add_foreign_key "companies", "prefectures"
  add_foreign_key "company_business_categories", "companies"
  add_foreign_key "searched_keywords", "users"
  add_foreign_key "subsidy_business_categories", "subsidies"
  add_foreign_key "subsidy_cities", "cities"
  add_foreign_key "subsidy_cities", "subsidies"
  add_foreign_key "subsidy_drafts", "cities"
  add_foreign_key "subsidy_drafts", "ministries"
  add_foreign_key "subsidy_drafts", "prefectures"
  add_foreign_key "subsidy_keywords", "subsidies"
  add_foreign_key "subsidy_ministries", "ministries"
  add_foreign_key "subsidy_ministries", "subsidies"
  add_foreign_key "subsidy_prefectures", "prefectures"
  add_foreign_key "subsidy_prefectures", "subsidies"
  add_foreign_key "user_favorite_subsidies", "subsidies"
  add_foreign_key "user_favorite_subsidies", "users"
  add_foreign_key "users", "companies"
end
