class CreateBlogPostImage < ActiveRecord::Migration
  def change
    create_table :blog_post_images do |t|
      t.string :local_identifier
      t.string :remote_url
      t.integer :organization_id
      t.index :organization_id
    end
  end
end
