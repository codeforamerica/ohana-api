class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.belongs_to :location, null: false
      t.text :number, null: false
      t.text :department
      t.text :extension
      t.text :number_type
      t.text :vanity_number

      t.timestamps
    end
    add_index :phones, :location_id
  end
end
