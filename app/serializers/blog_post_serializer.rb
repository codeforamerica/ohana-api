class BlogPostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :posted_at, :user_id, :is_published, :organization_id

  has_one :user, serializer: UserSerializer
  has_one :organization, serializer: OrganizationSerializer
  has_many :categories

  def posted_at
    object.posted_at.utc
  end
end
