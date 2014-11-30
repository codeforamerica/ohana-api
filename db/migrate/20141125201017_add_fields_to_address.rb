class AddFieldsToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :country_code, :string
    add_column :addresses, :street_1, :string
    add_column :addresses, :street_2, :string
    add_column :addresses, :postal_code, :string
    add_column :addresses, :state_province, :string
  end
end
