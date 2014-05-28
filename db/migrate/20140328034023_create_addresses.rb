class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :location
      t.text :street, null: false
      t.text :city, null: false
      t.text :state, null: false
      t.text :zip, null: false

      t.timestamps
    end
    add_index :addresses, :location_id
  end
end
