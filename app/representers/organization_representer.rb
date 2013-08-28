require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'

module OrganizationRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :id
  property :name

  property :url
  property :locations_url

  def url
    "#{root_url}organizations/#{self.id}"
  end

  def locations_url
    "#{root_url}organizations/#{self.id}/locations"
  end
end
