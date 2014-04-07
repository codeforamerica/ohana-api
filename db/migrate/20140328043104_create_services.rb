class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.belongs_to :location
      t.text :audience
      t.text :description
      t.text :eligibility
      t.text :fees
      t.text :how_to_apply
      t.text :name
      t.text :short_desc
      t.text :urls
      t.text :wait
      t.text :funding_sources
      t.text :service_areas
      t.text :keywords

      t.timestamps
    end
    add_index :services, :location_id
  end
end
