class AddFieldsToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :alternate_name, :string
    add_column :organizations, :date_incorporated, :date
    add_column :organizations, :description, :text
    add_column :organizations, :email, :string
    add_column :organizations, :legal_status, :string
    add_column :organizations, :tax_id, :string
    add_column :organizations, :tax_status, :string
    add_column :organizations, :website, :string
    add_column :organizations, :funding_sources, :string, array: true, default: []
    add_column :organizations, :accreditations, :string, array: true, default: []
    add_column :organizations, :licenses, :string, array: true, default: []

    remove_column :organizations, :urls, :string
  end
end
