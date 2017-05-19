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

ActiveRecord::Schema.define(version: 20170514024307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.string "sha"
    t.text "description"
    t.string "doi"
    t.jsonb "properties"
    t.integer "user_id"
    t.boolean "visible", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doi"], name: "index_lists_on_doi", unique: true
    t.index ["properties"], name: "index_lists_on_properties", using: :gin
    t.index ["sha"], name: "index_lists_on_sha", unique: true
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "things", force: :cascade do |t|
    t.jsonb "properties"
    t.string "sha"
    t.integer "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_things_on_list_id"
    t.index ["properties"], name: "index_things_on_properties", using: :gin
    t.index ["sha"], name: "index_things_on_sha", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "oauth_token"
    t.string "oauth_expires_at"
    t.string "email"
    t.string "sha"
    t.hstore "extra"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
