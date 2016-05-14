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

ActiveRecord::Schema.define(version: 20160514203244) do

  create_table "items", force: :cascade do |t|
    t.integer  "item_hash",      limit: 8
    t.string   "name",           limit: 255
    t.text     "description",    limit: 65535
    t.string   "icon",           limit: 255
    t.integer  "tier_type",      limit: 4
    t.string   "tier_type_name", limit: 255
    t.string   "item_type_name", limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "items", ["item_hash"], name: "index_items_on_item_hash", using: :btree

  create_table "stats", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "stat_hash",   limit: 8
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "stats", ["stat_hash"], name: "index_stats_on_stat_hash", using: :btree

  create_table "values", force: :cascade do |t|
    t.integer  "item_id",       limit: 4
    t.integer  "stat_hash",     limit: 8
    t.integer  "value",         limit: 4
    t.integer  "minimum_value", limit: 4
    t.integer  "maximum_value", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "values", ["item_id"], name: "index_values_on_item_id", using: :btree
  add_index "values", ["stat_hash"], name: "index_values_on_stat_hash", using: :btree

  create_table "weapons", force: :cascade do |t|
    t.integer  "item_hash",        limit: 4
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.string   "category",         limit: 255
    t.string   "tier",             limit: 255
    t.string   "icon",             limit: 255
    t.integer  "attack",           limit: 4
    t.integer  "optics",           limit: 4
    t.integer  "rate_of_fire",     limit: 4
    t.integer  "impact",           limit: 4
    t.integer  "range",            limit: 4
    t.integer  "stability",        limit: 4
    t.integer  "magazine",         limit: 4
    t.integer  "reload_speed",     limit: 4
    t.integer  "inventory_size",   limit: 4
    t.integer  "equip_speed",      limit: 4
    t.integer  "aim_assistance",   limit: 4
    t.integer  "recoil_direction", limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_foreign_key "values", "items"
end
