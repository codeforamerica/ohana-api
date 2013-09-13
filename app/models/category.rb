class Category
  include Mongoid::Document
  include Grape::Entity::DSL
  acts_as_nested_set

  has_and_belongs_to_many :services
  #has_many :services

  entity do
    expose :id
    expose :oe_id
    expose :name
    expose :parent_id
  end
end