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

ActiveRecord::Schema.define(version: 20170917162921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.bigint "item_hash"
    t.string "name", limit: 255
    t.text "description"
    t.string "icon", limit: 255
    t.integer "tier_type"
    t.string "tier_type_name", limit: 255
    t.string "item_type_name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "item_type"
    t.index ["item_hash"], name: "index_items_on_item_hash"
  end

  create_table "stats", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.bigint "stat_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stat_hash"], name: "index_stats_on_stat_hash"
  end

  create_table "values", force: :cascade do |t|
    t.integer "item_id"
    t.bigint "stat_hash"
    t.integer "value"
    t.integer "minimum_value"
    t.integer "maximum_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_values_on_item_id"
    t.index ["stat_hash"], name: "index_values_on_stat_hash"
  end

  add_foreign_key "values", "items"
end
