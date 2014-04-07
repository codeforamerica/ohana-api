class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.belongs_to :organization
      t.text :accessibility
      t.text :admin_emails
      t.text :description
      t.text :emails
      t.text :hours
      t.text :kind
      t.float :latitude
      t.float :longitude
      t.text :languages
      t.text :name
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
