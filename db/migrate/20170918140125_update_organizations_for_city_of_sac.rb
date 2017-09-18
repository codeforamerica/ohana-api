class UpdateOrganizationsForCityOfSac < ActiveRecord::Migration
  def change
    add_column :organizations, :twitter, :string
    add_column :organizations, :facebook, :string
    add_column :organizations, :linkedin, :string

    remove_column :organizations, :accreditations, :string
    remove_column :organizations, :date_incorporated, :date
    remove_column :organizations, :funding_sources, :string
    remove_column :organizations, :legal_status, :string
    remove_column :organizations, :licenses, :string
    remove_column :organizations, :tax_id, :string
    remove_column :organizations, :tax_status, :string
  end
end
