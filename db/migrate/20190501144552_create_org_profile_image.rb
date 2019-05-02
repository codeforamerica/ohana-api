class CreateOrgProfileImage < ActiveRecord::Migration
  def change
    create_table :org_profile_images do |t|
      t.string :local_identifier
      t.string :remote_url
      t.integer :organization_id
      t.index :organization_id
      t.string :image
    end
  end
end
