class CreateExams < ActiveRecord::Migration[6.0]
  def change
    create_table :exams do |t|
      t.string :name
      t.string :course
      t.string :professor
      t.references :college, index: true, foreign_key: true
      t.timestamps
    end
  end
end
