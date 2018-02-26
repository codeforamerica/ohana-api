class AddNewFieldsFromUpstream < ActiveRecord::Migration
  def change
    add_column :addresses, :address_1, :string
    add_column :addresses, :address_2, :string
    add_column :addresses, :country, :string
    add_column :mail_addresses, :address_1, :string
    add_column :mail_addresses, :address_2, :string
    add_column :mail_addresses, :country, :string
    add_column :services, :application_process, :string
  end
end
