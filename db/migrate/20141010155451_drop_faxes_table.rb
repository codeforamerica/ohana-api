class DropFaxesTable < ActiveRecord::Migration
  def up
    drop_table :faxes
  end

  def down
    create_table :faxes do |t|
      t.belongs_to :location
      t.text :number
      t.text :department

      t.timestamps
    end
    add_index :faxes, :location_id
  end
end
