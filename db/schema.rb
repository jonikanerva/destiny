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

ActiveRecord::Schema.define(version: 20160904064249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.bigint   "item_hash"
    t.string   "name",           limit: 255
    t.text     "description"
    t.string   "icon",           limit: 255
    t.integer  "tier_type"
    t.string   "tier_type_name", limit: 255
    t.string   "item_type_name", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["item_hash"], name: "index_items_on_item_hash", using: :btree
  end

  create_table "stats", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.bigint   "stat_hash"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["stat_hash"], name: "index_stats_on_stat_hash", using: :btree
  end

  create_table "values", force: :cascade do |t|
    t.integer  "item_id"
    t.bigint   "stat_hash"
    t.integer  "value"
    t.integer  "minimum_value"
    t.integer  "maximum_value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["item_id"], name: "index_values_on_item_id", using: :btree
    t.index ["stat_hash"], name: "index_values_on_stat_hash", using: :btree
  end

  create_table "weapons", force: :cascade do |t|
    t.bigint   "item_hash"
    t.string   "name",                 limit: 255
    t.text     "description"
    t.string   "category",             limit: 255
    t.string   "tier",                 limit: 255
    t.string   "icon",                 limit: 255
    t.integer  "attack"
    t.integer  "optics"
    t.integer  "rate_of_fire"
    t.integer  "impact"
    t.integer  "range"
    t.integer  "stability"
    t.integer  "magazine"
    t.integer  "reload_speed"
    t.integer  "inventory_size"
    t.integer  "equip_speed"
    t.integer  "aim_assistance"
    t.integer  "recoil_direction"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "tier_number"
    t.integer  "charge_rate"
    t.integer  "velocity"
    t.integer  "blast_radius"
    t.integer  "optics_min"
    t.integer  "optics_max"
    t.integer  "rate_of_fire_min"
    t.integer  "rate_of_fire_max"
    t.integer  "charge_rate_min"
    t.integer  "charge_rate_max"
    t.integer  "velocity_min"
    t.integer  "velocity_max"
    t.integer  "blast_radius_min"
    t.integer  "blast_radius_max"
    t.integer  "impact_min"
    t.integer  "impact_max"
    t.integer  "range_min"
    t.integer  "range_max"
    t.integer  "stability_min"
    t.integer  "stability_max"
    t.integer  "magazine_min"
    t.integer  "magazine_max"
    t.integer  "reload_speed_min"
    t.integer  "reload_speed_max"
    t.integer  "inventory_size_min"
    t.integer  "inventory_size_max"
    t.integer  "equip_speed_min"
    t.integer  "equip_speed_max"
    t.integer  "aim_assistance_min"
    t.integer  "aim_assistance_max"
    t.integer  "recoil_direction_min"
    t.integer  "recoil_direction_max"
    t.integer  "attack_min"
    t.integer  "attack_max"
    t.index ["category"], name: "index_weapons_on_category", using: :btree
  end

  add_foreign_key "values", "items"
end
