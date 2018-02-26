class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.belongs_to :organization, null: false
      t.text :accessibility
      t.text :admin_emails
      t.text :ask_for
      t.text :description
      t.text :emails
      t.text :hours
      t.integer :importance, default: 1
      t.text :kind, null: false
      t.float :latitude
      t.float :longitude
      t.text :languages
      t.boolean :market_match, default: false
      t.text :name, null: false
      t.text :payments
      t.text :products
      t.text :short_desc
      t.text :transportation
      t.text :urls
      t.text :slug

      t.timestamps
    end
    add_index :locations, :slug, unique: true
    add_index :locations, :organization_id
    add_index :locations, [:latitude, :longitude]
  end
end
