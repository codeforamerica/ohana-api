class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.datetime :posted_at, null: false
      t.integer :admin_id, null: false
      t.boolean :is_published, default: false
      t.timestamps null: false
    end
  end
end
