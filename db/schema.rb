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

ActiveRecord::Schema.define(version: 20201118125444) do

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
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "line"
    t.string   "email"
    t.string   "district"
    t.string   "company"
    t.integer  "section_id"
    t.decimal  "cash",       precision: 8, scale: 2
    t.index ["order_id"], name: "index_clients_on_order_id"
    t.index ["section_id"], name: "index_clients_on_section_id"
  end

  create_table "close_days", force: :cascade do |t|
    t.integer  "stock_id"
    t.date     "day"
    t.decimal  "initial",    precision: 10, scale: 2
    t.decimal  "final",      precision: 10, scale: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["stock_id"], name: "index_close_days_on_stock_id"
  end

  create_table "dye_inks", force: :cascade do |t|
    t.string  "quantity"
    t.integer "dye_id"
    t.integer "ink_id"
    t.index ["dye_id"], name: "index_dye_inks_on_dye_id"
    t.index ["ink_id"], name: "index_dye_inks_on_ink_id"
  end

  create_table "dyes", force: :cascade do |t|
    t.string  "name"
    t.decimal "price",   precision: 8, scale: 2
    t.integer "item_id"
    t.index ["item_id"], name: "index_dyes_on_item_id"
  end

  create_table "exception_tracks", force: :cascade do |t|
    t.string   "title"
    t.text     "body",       limit: 16777215
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "fabricantes", force: :cascade do |t|
    t.integer  "fabricante_id"
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
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

  create_table "inks", force: :cascade do |t|
    t.string  "collection"
    t.string  "code"
    t.string  "name"
    t.string  "message"
    t.integer "sw_product_id"
    t.integer "sw_base_id"
    t.integer "sw_recipient_id"
    t.index ["code"], name: "index_inks_on_code"
    t.index ["collection"], name: "index_inks_on_collection"
    t.index ["name"], name: "index_inks_on_name"
    t.index ["sw_base_id"], name: "index_inks_on_sw_base_id"
    t.index ["sw_product_id"], name: "index_inks_on_sw_product_id"
    t.index ["sw_recipient_id"], name: "index_inks_on_sw_recipient_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.integer  "group_id"
    t.integer  "family_id"
    t.integer  "subgroup_id"
    t.decimal  "price",         precision: 10, scale: 2
    t.boolean  "active",                                 default: true
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "image"
    t.decimal  "virtual_price", precision: 10, scale: 2
    t.index ["code"], name: "index_items_on_code", unique: true
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

  create_table "order_inks", force: :cascade do |t|
    t.integer  "order_id"
    t.decimal  "quantity",     precision: 10, scale: 2
    t.decimal  "decimal",      precision: 10, scale: 2
    t.string   "name"
    t.decimal  "price",        precision: 10, scale: 2
    t.string   "brand"
    t.integer  "recipient_id"
    t.integer  "base_id"
    t.integer  "product_id"
    t.integer  "ink_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["order_id"], name: "index_order_inks_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.decimal  "quantity",   precision: 10, scale: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "price",      precision: 10, scale: 2
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "order_tinta", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "rformula_id"
    t.decimal  "quantity",     precision: 10, scale: 1
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "can"
    t.integer  "tinta_cor_id"
    t.index ["order_id"], name: "index_order_tinta_on_order_id"
    t.index ["rformula_id"], name: "index_order_tinta_on_rformula_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.decimal  "total",        precision: 10, scale: 2
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "user_id"
    t.integer  "client_id"
    t.string   "obs"
    t.string   "seller"
    t.boolean  "coupon",                                default: false
    t.datetime "paid_at"
    t.datetime "submited_at"
    t.decimal  "cc_value",     precision: 10, scale: 1, default: "0.0"
    t.boolean  "boleto",                                default: false
    t.decimal  "discount",     precision: 10, scale: 2, default: "0.0"
    t.decimal  "shipping",     precision: 10, scale: 2, default: "0.0"
    t.decimal  "boleto_value", precision: 10, scale: 1, default: "0.0"
    t.boolean  "printed",                               default: false
    t.decimal  "cashed",       precision: 10, scale: 2
    t.boolean  "credito",                               default: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "outputs", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "value",       precision: 10, scale: 1
    t.integer  "stock_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.text     "description"
    t.integer  "output_type"
    t.index ["stock_id"], name: "index_outputs_on_stock_id"
    t.index ["user_id"], name: "index_outputs_on_user_id"
  end

  create_table "product_base_items", force: :cascade do |t|
    t.integer "sw_product_id"
    t.integer "sw_base_id"
    t.integer "sw_recipient_id"
    t.integer "item_id"
    t.index ["item_id"], name: "index_product_base_items_on_item_id"
    t.index ["sw_base_id"], name: "index_product_base_items_on_sw_base_id"
    t.index ["sw_product_id"], name: "index_product_base_items_on_sw_product_id"
    t.index ["sw_recipient_id"], name: "index_product_base_items_on_sw_recipient_id"
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

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "stock_changes", force: :cascade do |t|
    t.integer  "stock_id"
    t.integer  "item_id"
    t.string   "state"
    t.string   "observation"
    t.decimal  "quantity",          precision: 8, scale: 2
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "stock_transfer_id"
    t.index ["item_id"], name: "index_stock_changes_on_item_id"
    t.index ["stock_id"], name: "index_stock_changes_on_stock_id"
  end

  create_table "stock_counts", force: :cascade do |t|
    t.integer  "stock_id"
    t.integer  "item_id"
    t.boolean  "checked",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["item_id"], name: "index_stock_counts_on_item_id"
    t.index ["stock_id"], name: "index_stock_counts_on_stock_id"
  end

  create_table "stock_items", force: :cascade do |t|
    t.integer  "stock_id"
    t.integer  "item_id"
    t.decimal  "quantity",   precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["item_id"], name: "index_stock_items_on_item_id"
    t.index ["stock_id"], name: "index_stock_items_on_stock_id"
  end

  create_table "stock_locations", force: :cascade do |t|
    t.integer  "stock_id"
    t.integer  "item_id"
    t.string   "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_stock_locations_on_item_id"
    t.index ["stock_id"], name: "index_stock_locations_on_stock_id"
  end

  create_table "stock_transfers", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stock_transfers_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stocks_on_user_id"
  end

  create_table "subgroups", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sw_bases", force: :cascade do |t|
    t.string  "name"
    t.integer "item_id"
    t.index ["item_id"], name: "index_sw_bases_on_item_id"
  end

  create_table "sw_products", force: :cascade do |t|
    t.string "name"
  end

  create_table "sw_recipients", force: :cascade do |t|
    t.string "name"
    t.string "capacity"
  end

  create_table "tinta_acabamento_base_items", force: :cascade do |t|
    t.integer  "tinta_acabamento_id"
    t.integer  "tinta_base_id"
    t.integer  "item_id"
    t.integer  "tinta_embalagem_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["item_id"], name: "index_tinta_acabamento_base_items_on_item_id"
    t.index ["tinta_acabamento_id"], name: "index_tinta_acabamento_base_items_on_tinta_acabamento_id"
    t.index ["tinta_base_id"], name: "index_tinta_acabamento_base_items_on_tinta_base_id"
    t.index ["tinta_embalagem_id"], name: "index_tinta_acabamento_base_items_on_tinta_embalagem_id"
  end

  create_table "tinta_acabamentos", force: :cascade do |t|
    t.integer  "tinta_acabamento_id"
    t.string   "descricao"
    t.integer  "tinta_produto_id"
    t.string   "itnegracao_old"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["tinta_produto_id"], name: "index_tinta_acabamentos_on_tinta_produto_id"
  end

  create_table "tinta_bases", force: :cascade do |t|
    t.integer  "tinta_base_id"
    t.string   "descricao"
    t.string   "integracao_old"
    t.integer  "fabricante_id"
    t.decimal  "preco",          precision: 10, scale: 2
    t.integer  "item_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "tinta_cors", force: :cascade do |t|
    t.integer  "tinta_cor_id"
    t.string   "codigo"
    t.string   "descricao"
    t.integer  "tinta_acabamento_id"
    t.integer  "tinta_base_id"
    t.string   "observacao"
    t.integer  "quantidade"
    t.text     "formula"
    t.integer  "fabricante_id"
    t.string   "integracao_old"
    t.decimal  "quantidade_old",      precision: 10, scale: 2
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "tinta_embalagem_id"
    t.index ["fabricante_id"], name: "index_tinta_cors_on_fabricante_id"
    t.index ["tinta_acabamento_id"], name: "index_tinta_cors_on_tinta_acabamento_id"
    t.index ["tinta_base_id"], name: "index_tinta_cors_on_tinta_base_id"
  end

  create_table "tinta_embalagems", force: :cascade do |t|
    t.integer  "tinta_embalagem_id"
    t.string   "descricao"
    t.decimal  "quantidade",         precision: 10, scale: 2
    t.decimal  "quantidade_old",     precision: 10, scale: 2
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "tinta_pigmento_items", force: :cascade do |t|
    t.integer  "tinta_pigmento_id"
    t.integer  "tinta_pigmento_item_id"
    t.integer  "item_id"
    t.integer  "codigo_numerico"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tinta_pigmentos", force: :cascade do |t|
    t.integer  "tinta_pigmento_id"
    t.string   "codigo"
    t.string   "descricao"
    t.string   "integracao_old"
    t.integer  "fabricante_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.decimal  "price",             precision: 10, scale: 2
  end

  create_table "tinta_produtos", force: :cascade do |t|
    t.integer  "tinta_produto_id"
    t.string   "descricao"
    t.integer  "integracao_id"
    t.integer  "fabricante_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.integer  "role"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "username"
    t.string   "name"
    t.integer  "default_stock_id"
    t.boolean  "super_role",             default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "wanda_inks", force: :cascade do |t|
    t.string   "description"
    t.string   "code"
    t.decimal  "price"
    t.string   "recipient"
    t.string   "base"
    t.string   "product"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
