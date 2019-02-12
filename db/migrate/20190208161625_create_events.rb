class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :body
      t.datetime :posted_at, null: false
      t.datetime :starting_at, null: false
      t.datetime :ending_at, null: false
      t.string :street_1, null: false
      t.string :street_2
      t.string :city, null: false
      t.string :state_abbr
      t.string :zip
      t.string :phone
      t.string :external_url
      t.boolean :is_featured, default: false
      t.integer :organization_id, null: false
      t.integer :admin_id, null: false
      t.timestamps null: false
    end
  end
end
