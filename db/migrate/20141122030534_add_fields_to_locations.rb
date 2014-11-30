class AddFieldsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :alternate_name, :string
    add_column :locations, :virtual, :boolean, default: false
    add_column :locations, :active, :boolean, default: true
    add_index :locations, :active
    add_column :locations, :email, :string
    add_column :locations, :website, :string
  end
end
