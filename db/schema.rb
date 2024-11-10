# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_11_09_213323) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assessment_items", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tree_id"
    t.index ["tree_id"], name: "index_assessment_items_on_tree_id"
  end

  create_table "blossom_assessments", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "assessment_item_id", null: false
    t.integer "blossom_id", null: false
    t.string "stage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "branch_id"
    t.index ["assessment_item_id"], name: "index_blossom_assessments_on_assessment_item_id"
    t.index ["blossom_id"], name: "index_blossom_assessments_on_blossom_id"
    t.index ["student_id"], name: "index_blossom_assessments_on_student_id"
  end

  create_table "blossoms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "position"
    t.integer "row"
    t.integer "column"
    t.integer "branch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stage"
    t.boolean "assign"
    t.index ["branch_id"], name: "index_blossoms_on_branch_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "tree_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tree_id"], name: "index_branches_on_tree_id"
  end

  create_table "documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "blossom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blossom_id"], name: "index_resources_on_blossom_id"
  end

  create_table "session_goals", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "tree_id", null: false
    t.date "date"
    t.text "goal"
    t.text "evidence"
    t.integer "self_assess"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "goal_type"
    t.index ["student_id"], name: "index_session_goals_on_student_id"
    t.index ["tree_id"], name: "index_session_goals_on_tree_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "teacher_id", null: false
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
    t.index ["teacher_id"], name: "index_students_on_teacher_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  end

  create_table "tree_shares", force: :cascade do |t|
    t.integer "tree_id", null: false
    t.integer "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_tree_shares_on_teacher_id"
    t.index ["tree_id"], name: "index_tree_shares_on_tree_id"
  end

  create_table "trees", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cutoff_a"
    t.integer "cutoff_b"
    t.integer "cutoff_c"
    t.integer "cutoff_d"
    t.integer "teacher_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assessment_items", "trees"
  add_foreign_key "blossom_assessments", "assessment_items"
  add_foreign_key "blossom_assessments", "blossoms"
  add_foreign_key "blossom_assessments", "students"
  add_foreign_key "blossoms", "branches"
  add_foreign_key "branches", "trees"
  add_foreign_key "resources", "blossoms"
  add_foreign_key "session_goals", "students"
  add_foreign_key "session_goals", "trees"
  add_foreign_key "students", "teachers"
  add_foreign_key "tree_shares", "teachers"
  add_foreign_key "tree_shares", "trees"
end
