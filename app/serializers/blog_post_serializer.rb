class BlogPostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :posted_at, :user_id, :is_published, :organization_id

  has_one :user, serializer: UserSerializer
  has_one :organization, serializer: OrganizationSerializer
  has_many :blog_post_attachments, serializer: BlogPostAttachmentSerializer
  has_many :categories
end
