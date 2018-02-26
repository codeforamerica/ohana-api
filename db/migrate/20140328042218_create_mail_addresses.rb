class CreateMailAddresses < ActiveRecord::Migration
  def change
    create_table :mail_addresses do |t|
      t.belongs_to :location
      t.text :attention
      t.text :street, null: false
      t.text :city, null: false
      t.text :state, null: false
      t.text :zip, null: false

      t.timestamps
    end
    add_index :mail_addresses, :location_id
  end
end
