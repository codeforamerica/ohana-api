class UpdateOrganizationsForCityOfSac < ActiveRecord::Migration
  def change
    add_column :organizations, :twitter, :string
    add_column :organizations, :facebook, :string
    add_column :organizations, :linkedin, :string
  end
end
