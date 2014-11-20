class AddFieldsToServices < ActiveRecord::Migration
  def change
    add_column :services, :accepted_payments, :string, array: true, default: []
    add_column :services, :alternate_name, :string
    add_column :services, :email, :string
    add_column :services, :languages, :string, array: true, default: []
    add_column :services, :required_documents, :string, array: true, default: []
    add_column :services, :status, :string
    add_column :services, :website, :string

    change_column_null :services, :how_to_apply, false
    change_column_null :services, :description, false

    remove_column :services, :short_desc, :string
    remove_column :services, :urls, :string

    add_index :services, :languages, using: 'gin'
  end
end
