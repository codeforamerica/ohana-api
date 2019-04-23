class ChangeBlogPostImageType < ActiveRecord::Migration
  def change
    remove_column :blog_posts, :image
    add_column :blog_posts, :images, :json
  end
end
