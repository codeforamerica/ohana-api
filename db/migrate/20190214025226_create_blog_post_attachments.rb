class CreateBlogPostAttachments < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE blog_post_attachments_file_type AS ENUM ('image', 'video', 'audio');
    SQL
    create_table :blog_post_attachments do |t|
      t.column :file_type, :blog_post_attachments_file_type
      t.string :file_url
      t.string :file_legend
      t.integer :order
      t.integer :blog_post_id

      t.timestamps null: false
    end
  end

  def down
    drop_table :blog_post_attachments

    execute <<-SQL
      DROP TYPE blog_post_attachments_file_type;
    SQL
  end
end
