class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :location
      t.text :street
      t.text :city
      t.text :state
      t.text :zip

      t.timestamps
    end
    add_index :addresses, :location_id
  end
end
