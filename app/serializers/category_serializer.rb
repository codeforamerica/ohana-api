class CategorySerializer < ActiveModel::Serializer
  attributes :id, :depth, :taxonomy_id, :name, :parent_id
end
