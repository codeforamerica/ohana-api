class CreateApiApplications < ActiveRecord::Migration
  def change
    create_table :api_applications do |t|
      t.belongs_to :user
      t.text :name
      t.text :main_url
      t.text :callback_url
      t.text :api_token

      t.timestamps
    end
    add_index :api_applications, :user_id
    add_index :api_applications, :api_token, unique: true
  end
end
