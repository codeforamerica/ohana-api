class RemoveUnusedFields < ActiveRecord::Migration
  def change
    remove_column :addresses, :street, :text
    remove_column :addresses, :state, :text
    remove_column :addresses, :zip, :text

    remove_column :mail_addresses, :street, :text
    remove_column :mail_addresses, :state, :text
    remove_column :mail_addresses, :zip, :text

    remove_column :services, :wait, :text
    remove_column :services, :urls, :text

    remove_column :locations, :urls, :text
    remove_column :locations, :emails, :text

    remove_column :contacts, :phone, :text
    remove_column :contacts, :fax, :text
    remove_column :contacts, :extension, :text

    drop_table :faxes
  end
end
