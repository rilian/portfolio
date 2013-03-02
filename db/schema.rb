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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130302082734) do

  create_table "albums", :force => true do |t|
    t.string  "title",                                 :null => false
    t.boolean "is_hidden",          :default => false
    t.integer "weight",             :default => 0
    t.boolean "is_upload_to_stock", :default => true
  end

  add_index "albums", ["is_hidden"], :name => "index_albums_on_is_hidden"
  add_index "albums", ["title"], :name => "index_albums_on_title", :unique => true
  add_index "albums", ["weight"], :name => "index_albums_on_weight"

  create_table "images", :force => true do |t|
    t.integer  "album_id"
    t.string   "asset"
    t.string   "title"
    t.string   "place"
    t.text     "desc"
    t.date     "date"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.datetime "published_at"
    t.string   "tags_cache"
    t.string   "flickr_photo_id",     :limit => 11
    t.string   "deviantart_link"
    t.string   "istockphoto_link"
    t.string   "shutterstock_link"
    t.integer  "flickr_comment_time",               :default => 0
    t.boolean  "is_for_sale",                       :default => false
    t.integer  "image_width"
    t.integer  "image_height"
  end

  add_index "images", ["album_id"], :name => "index_images_on_album_id"
  add_index "images", ["published_at"], :name => "index_images_on_published_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
