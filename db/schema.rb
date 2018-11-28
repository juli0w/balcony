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

ActiveRecord::Schema.define(version: 20181127123104) do

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "phone"
    t.string   "uf"
    t.string   "cep"
    t.string   "cpf"
    t.date     "birthday"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "line"
    t.string   "email"
    t.string   "district"
    t.string   "company"
    t.integer  "section_id"
    t.index ["order_id"], name: "index_clients_on_order_id"
    t.index ["section_id"], name: "index_clients_on_section_id"
  end

  create_table "families", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "family_id"
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_groups_on_family_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.integer  "group_id"
    t.integer  "family_id"
    t.integer  "subgroup_id"
    t.decimal  "price",       precision: 10, scale: 2
    t.boolean  "active",                               default: true
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "image"
    t.index ["family_id"], name: "index_items_on_family_id"
    t.index ["group_id"], name: "index_items_on_group_id"
    t.index ["subgroup_id"], name: "index_items_on_subgroup_id"
  end

  create_table "listings", force: :cascade do |t|
    t.string   "items"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "order_tinta", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "rformula_id"
    t.integer  "quantity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["order_id"], name: "index_order_tinta_on_order_id"
    t.index ["rformula_id"], name: "index_order_tinta_on_rformula_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.decimal  "total",      precision: 10, scale: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "user_id"
    t.integer  "client_id"
    t.string   "obs"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "rbases", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.decimal  "density",    precision: 8,  scale: 2
    t.integer  "rgb"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "price",      precision: 10, scale: 2
  end

  create_table "rcolors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rformulas", force: :cascade do |t|
    t.integer  "rproduct_id"
    t.string   "color"
    t.string   "base"
    t.string   "line"
    t.string   "rgb"
    t.integer  "c1"
    t.decimal  "q1",          precision: 10, scale: 2
    t.integer  "c2"
    t.decimal  "q2",          precision: 10, scale: 2
    t.integer  "c3"
    t.decimal  "q3",          precision: 10, scale: 2
    t.integer  "c4"
    t.decimal  "q4",          precision: 10, scale: 2
    t.integer  "c5"
    t.decimal  "q5",          precision: 10, scale: 2
    t.integer  "c6"
    t.decimal  "q6",          precision: 10, scale: 2
    t.string   "notes"
    t.decimal  "price",       precision: 10, scale: 2
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "rcolor_id"
    t.integer  "rline_id"
    t.index ["rcolor_id"], name: "index_rformulas_on_rcolor_id"
    t.index ["rline_id"], name: "index_rformulas_on_rline_id"
    t.index ["rproduct_id"], name: "index_rformulas_on_rproduct_id"
  end

  create_table "rintegrations", force: :cascade do |t|
    t.string   "base"
    t.string   "can"
    t.string   "line"
    t.string   "product"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_rintegrations_on_item_id"
  end

  create_table "rlines", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rproducts", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "base"
    t.decimal  "density",    precision: 8, scale: 2
    t.string   "can"
    t.integer  "item_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["item_id"], name: "index_rproducts_on_item_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subgroups", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
