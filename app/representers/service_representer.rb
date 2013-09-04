require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'

module ServiceRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :audience
  property :description
  property :eligibility
  property :fees
  property :funding_sources
  property :keywords
  collection :categories, extend: CategoryRepresenter, class: Category
  property :how_to_apply
  property :name
  property :service_areas
  property :short_desc
  property :urls
  property :wait

end
