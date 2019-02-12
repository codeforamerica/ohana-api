class BlogPostSerializer < ActiveModel::Serializer
  attributes :id, :title, :image_legend, :body, :posted_at, :admin_id, :is_published
  has_many :categories

  has_one :admin, serializer: AdminSerializer
end
