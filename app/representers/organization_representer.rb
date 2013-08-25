require 'roar/representer/json'
require 'roar/representer/feature/hypermedia'

module OrganizationRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :id
  property :name

  link :self do
    "#{root_url}organizations/#{self.id}"
  end

  link :locations do
    "#{root_url}organizations/#{self.id}/locations"
  end

end
