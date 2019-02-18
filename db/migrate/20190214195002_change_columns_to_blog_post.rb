class ChangeColumnsToBlogPost < ActiveRecord::Migration
  def change
    remove_column :blog_posts, :image_legend, :string
    add_column :blog_posts, :organization_id, :integer
  end
end
