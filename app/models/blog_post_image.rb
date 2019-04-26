class BlogPostImage < ActiveRecord::Base
    attr_accessible :local_identifier, :remote_url, :organization_id, :image
    mount_uploader :image, BlogPostImageUploader
end
