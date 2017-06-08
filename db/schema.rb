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

ActiveRecord::Schema.define(version: 20160829235003) do

  create_table "coordinates", force: :cascade do |t|
    t.float "latitude"
    t.float "longtitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coordinates_neighborhoods", force: :cascade do |t|
    t.integer "neighborhood_id"
    t.integer "coordinate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trigrams", force: :cascade do |t|
    t.string "trigram", limit: 3
    t.integer "score", limit: 2
    t.integer "owner_id"
    t.string "owner_type"
    t.string "fuzzy_field"
    t.index ["owner_id", "owner_type", "fuzzy_field", "trigram", "score"], name: "index_for_match"
    t.index ["owner_id", "owner_type"], name: "index_by_owner"
  end

end
