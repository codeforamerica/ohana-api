class AddSuperAdminToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :super_admin, :boolean, default: false
  end
end
