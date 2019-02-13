class AddColumnsToOrganization < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE post_approval_statuses AS ENUM ('pending', 'approved', 'denied');
      ALTER TABLE organizations ADD approval_status post_approval_statuses;
    SQL

    add_column :organizations, :is_published, :boolean, default: false
    add_column :organizations, :admin_id, :integer
  end

  def down
    remove_column :organizations, :approval_status
    execute <<-SQL
      DROP TYPE post_approval_statuses;
    SQL
    remove_column :organizations, :is_published, :boolean
    remove_column :organizations, :admin_id, :integer
  end
end
