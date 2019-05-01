class AddImageToBlogPostImages < ActiveRecord::Migration
  def change
    add_column :blog_post_images, :image, :string
  end
end
