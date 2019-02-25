class AddDefaultTagsForBlogPosts < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute("TRUNCATE tags RESTART IDENTITY;")
    Tag.delete_all
    ['featured', 'front page'].each do |tag|
      Tag.create!(
        name: tag
      )
    end
  end
end
