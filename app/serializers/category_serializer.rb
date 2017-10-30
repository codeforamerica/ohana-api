class CategorySerializer < ActiveModel::Serializer
  attributes :id, :depth, :taxonomy_id, :name, :slug, :parent_id
end
