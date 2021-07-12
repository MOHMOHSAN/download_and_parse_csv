# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_11_135554) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customer_product_relationships", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "product_id", null: false
    t.bigint "customer_id", null: false
    t.index ["customer_id"], name: "index_customer_product_relationships_on_customer_id"
    t.index ["product_id"], name: "index_customer_product_relationships_on_product_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "product_name"
    t.decimal "price"
    t.index ["product_name"], name: "index_products_on_product_name", unique: true
  end

  add_foreign_key "customer_product_relationships", "customers"
  add_foreign_key "customer_product_relationships", "products"
end
