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

ActiveRecord::Schema.define(version: 2022_01_12_080148) do

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url", default: "", null: false
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "ministries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_ministries_on_name", unique: true
  end

  create_table "prefectures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_prefectures_on_name", unique: true
  end

  create_table "subsidies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "start_from", null: false
    t.date "end_to"
    t.index ["url"], name: "index_subsidies_on_url", unique: true, length: 256
  end

  create_table "subsidy_cities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_subsidy_cities_on_city_id"
    t.index ["subsidy_id", "city_id"], name: "index_subsidy_cities_on_subsidy_id_and_city_id", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_cities_on_subsidy_id"
  end

  create_table "subsidy_ministries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.bigint "ministry_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ministry_id"], name: "index_subsidy_ministries_on_ministry_id"
    t.index ["subsidy_id", "ministry_id"], name: "index_subsidy_ministries_on_subsidy_id_and_ministry_id", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_ministries_on_subsidy_id"
  end

  create_table "subsidy_prefectures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "subsidy_id", null: false
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_subsidy_prefectures_on_prefecture_id"
    t.index ["subsidy_id", "prefecture_id"], name: "index_subsidy_prefectures_on_subsidy_id_and_prefecture_id", unique: true
    t.index ["subsidy_id"], name: "index_subsidy_prefectures_on_subsidy_id"
  end

end
