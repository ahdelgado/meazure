class CreateExamWindows < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_windows do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.references :exam, index: true, foreign_key: true
    end
  end
end
