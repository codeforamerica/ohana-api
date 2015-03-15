class RenameFields < ActiveRecord::Migration
  def change
    rename_column :services, :how_to_apply, :application_process
    rename_column :addresses, :street_1, :address_1
    rename_column :addresses, :street_2, :address_2
    rename_column :addresses, :state, :state_province
    rename_column :addresses, :country_code, :country
    rename_column :mail_addresses, :street_1, :address_1
    rename_column :mail_addresses, :street_2, :address_2
    rename_column :mail_addresses, :state, :state_province
    rename_column :mail_addresses, :country_code, :country
  end
end
