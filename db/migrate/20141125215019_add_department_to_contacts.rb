class AddDepartmentToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :department, :string
  end
end
