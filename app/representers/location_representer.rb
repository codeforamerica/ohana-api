require 'roar/representer/json'
# require 'roar/representer/feature/hypermedia'

module LocationRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  property :id
  property :accessibility
  property :ask_for
  property :coordinates
  property :description
  property :emails
  property :faxes
  property :hours
  property :languages
  property :name
  property :phones
  property :short_desc
  property :transportation
  property :urls
  property :address, extend: AddressRepresenter, class: Address
  property :mail_address, extend: MailAddressRepresenter, class: MailAddress
  property :contacts
  property :updated_at

  property :organization, extend: OrganizationRepresenter, class: Organization

  collection :services, :extend => ServiceRepresenter, :class => Service

  # link :self do
  #   location_url(represented)
  # end

  # link :services do
  #   location_services_url
  # end
end
