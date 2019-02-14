class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :taggings_count
end