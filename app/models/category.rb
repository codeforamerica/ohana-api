class Category
  include Mongoid::Document
  include Mongoid::Slug
  include Grape::Entity::DSL
  acts_as_nested_set

  slug :name, history: true

  has_and_belongs_to_many :services
  #has_many :services

  entity do
    expose :id
    expose :depth
    expose :oe_id
    expose :name
    expose :parent_id
    expose :slugs
  end
end