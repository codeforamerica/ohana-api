class BlogPostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :posted_at, :admin_id, :is_published, :organization_id
  has_many :categories

  has_one :admin, serializer: AdminSerializer
  has_one :organization, serializer: OrganizationSerializer
  has_many :blog_post_attachments, serializer: BlogPostAttachmentSerializer
end
