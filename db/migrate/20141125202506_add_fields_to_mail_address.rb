class AddFieldsToMailAddress < ActiveRecord::Migration
  def change
    add_column :mail_addresses, :country_code, :string
    add_column :mail_addresses, :street_1, :string
    add_column :mail_addresses, :street_2, :string
    add_column :mail_addresses, :postal_code, :string
    add_column :mail_addresses, :state_province, :string
  end
end
