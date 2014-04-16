class CreateMailAddresses < ActiveRecord::Migration
  def change
    create_table :mail_addresses do |t|
      t.belongs_to :location
      t.text :attention
      t.text :street
      t.text :city
      t.text :state
      t.text :zip

      t.timestamps
    end
    add_index :mail_addresses, :location_id
  end
end
