class CreateFaxes < ActiveRecord::Migration
  def change
    create_table :faxes do |t|
      t.belongs_to :location, null: false
      t.text :number, null: false
      t.text :department

      t.timestamps
    end
    add_index :faxes, :location_id
  end
end
