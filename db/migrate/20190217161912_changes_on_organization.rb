class ChangesOnOrganization < ActiveRecord::Migration
  def change
    remove_column :organizations, :admin_id, :integer
    add_column :organizations, :user_id, :integer

    remove_column :blog_posts, :admin_id, :integer
    add_column :blog_posts, :user_id, :integer

    remove_column :events, :admin_id, :integer
    add_column :events, :user_id, :integer

    add_column :jwt_blacklist, :exp, :datetime, null: false
  end
end
