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

ActiveRecord::Schema[8.0].define(version: 2026_02_19_124431) do
  create_table "attendance_records", force: :cascade do |t|
    t.integer "student_id", null: false
    t.string "mac_address"
    t.string "event_type"
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_attendance_records_on_student_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "name"
    t.boolean "archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "student_id_number"
    t.string "block"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "classroom_id", null: false
    t.string "email"
    t.index ["classroom_id"], name: "index_students_on_classroom_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "mac_address"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_tags_on_student_id"
  end

  add_foreign_key "attendance_records", "students"
  add_foreign_key "students", "classrooms"
  add_foreign_key "tags", "students"
end
