class BlogPostAttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file_type, :file_url, :file_legend, :order
end
