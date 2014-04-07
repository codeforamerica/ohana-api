class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :location
      t.text :name
      t.text :title
      t.text :email
      t.text :fax
      t.text :phone
      t.text :extension

      t.timestamps
    end
    add_index :contacts, :location_id
  end
end
