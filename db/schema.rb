# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_211_120_225_638) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'addresses', force: :cascade do |t|
    t.string 'address1'
    t.string 'address2'
    t.string 'city'
    t.string 'state'
    t.string 'zip'
    t.string 'addressable_type'
    t.bigint 'addressable_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[addressable_type addressable_id], name: 'index_addresses_on_addressable_type_and_addressable_id'
  end

  create_table 'colleges', force: :cascade do |t|
    t.string 'name'
    t.string 'phone_number'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'exam_windows', force: :cascade do |t|
    t.datetime 'start_datetime'
    t.datetime 'end_datetime'
    t.bigint 'exam_id'
    t.index ['exam_id'], name: 'index_exam_windows_on_exam_id'
  end

  create_table 'exams', force: :cascade do |t|
    t.string 'name'
    t.string 'course'
    t.string 'professor'
    t.bigint 'college_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['college_id'], name: 'index_exams_on_college_id'
  end

  create_table 'registrations', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'exam_id'
    t.datetime 'start_datetime'
    t.index ['exam_id'], name: 'index_registrations_on_exam_id'
    t.index ['user_id'], name: 'index_registrations_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'phone_number'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'exam_windows', 'exams'
  add_foreign_key 'exams', 'colleges'
  add_foreign_key 'registrations', 'exams'
  add_foreign_key 'registrations', 'users'
end
