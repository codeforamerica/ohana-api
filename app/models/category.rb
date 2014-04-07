class Category < ActiveRecord::Base
  has_ancestry

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  attr_accessible :name, :oe_id

  has_and_belongs_to_many :services, uniq: true

  self.include_root_in_json = false

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :depth
    expose :oe_id
    expose :name
    expose :parent_id
    expose :slug
  end
end