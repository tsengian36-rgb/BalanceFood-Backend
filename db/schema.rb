# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
ActiveRecord::Schema[7.1].define(version: 2026_09_15_000005) do
  enable_extension "plpgsql"

  create_table "expenses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "menu_item_id"
    t.string "description", null: false
    t.integer "amount", null: false
    t.date "spent_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_expenses_on_menu_item_id"
    t.index ["user_id", "spent_on"], name: "index_expenses_on_user_id_and_spent_on"
    t.index ["user_id"], name: "index_expenses_on_user_id"
    t.check_constraint "amount > 0", name: "expenses_amount_positive"
  end

  create_table "menu_items", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "price", null: false
    t.string "category"
    t.boolean "available", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price"], name: "index_menu_items_on_price"
    t.index ["restaurant_id"], name: "index_menu_items_on_restaurant_id"
    t.check_constraint "price > 0", name: "menu_items_price_positive"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name", null: false
    t.string "category"
    t.string "address"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_restaurants_on_category"
    t.index ["name"], name: "index_restaurants_on_name"
  end

  create_table "revoked_tokens", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_revoked_tokens_on_jti", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "current_balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.check_constraint "current_balance >= 0", name: "users_balance_non_negative"
  end

  add_foreign_key "expenses", "menu_items"
  add_foreign_key "expenses", "users"
  add_foreign_key "menu_items", "restaurants"
end
