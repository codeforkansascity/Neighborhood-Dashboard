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

ActiveRecord::Schema.define(version: 20160410175316) do

  create_table "coordinates", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longtitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coordinates_neighborhoods", force: :cascade do |t|
    t.integer  "neighborhood_id"
    t.integer  "coordinate_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "coordinates_parcels", force: :cascade do |t|
    t.integer  "parcel_id"
    t.integer  "coordinate_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parcels", force: :cascade do |t|
    t.string   "object_id"
    t.string   "parcel_id"
    t.string   "apn"
    t.string   "own_name"
    t.string   "land_bank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
