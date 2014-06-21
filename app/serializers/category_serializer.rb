class CategorySerializer < ActiveModel::Serializer
  attributes :id, :depth, :oe_id, :name, :parent_id, :slug
end
