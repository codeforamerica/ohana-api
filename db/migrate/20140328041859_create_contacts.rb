class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :location, null: false
      t.text :name, null: false
      t.text :title, null: false
      t.text :email
      t.text :fax
      t.text :phone
      t.text :extension

      t.timestamps
    end
    add_index :contacts, :location_id
  end
end
