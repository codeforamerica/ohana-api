class AddLogoUrlToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :logo_url, :text
  end
end
