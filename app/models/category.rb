class Category < ActiveRecord::Base
  has_ancestry

  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :oe_id]
    ]
  end

  attr_accessible :name, :oe_id

  has_and_belongs_to_many :services, -> { uniq }

  validates_presence_of :name, :oe_id, message: "can't be blank for Category"

  default_scope { order('oe_id ASC') }

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
