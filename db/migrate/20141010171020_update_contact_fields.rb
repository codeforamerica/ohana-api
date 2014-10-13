class UpdateContactFields < ActiveRecord::Migration
  def change
    add_column :contacts, :department, :string
    remove_column :contacts, :fax, :string
    remove_column :contacts, :phone, :string
    remove_column :contacts, :extension, :string
  end
end
