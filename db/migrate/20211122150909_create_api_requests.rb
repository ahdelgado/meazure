class CreateApiRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :api_requests do |t|
      t.string :request_method
      t.string :controller_class
      t.string :path
      t.string :status
      t.string :message
      t.timestamps
    end
  end
end
