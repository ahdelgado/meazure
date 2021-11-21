class CreateRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :registrations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :exam, index: true, foreign_key: true
      t.datetime :start_datetime
    end
  end
end
