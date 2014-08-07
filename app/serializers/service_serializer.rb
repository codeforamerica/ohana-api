class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :audience, :description, :eligibility, :fees,
             :funding_sources, :how_to_apply, :keywords, :name,
             :service_areas, :short_desc, :urls, :wait, :updated_at

  # embed :ids, include: true
  has_many :categories
end
