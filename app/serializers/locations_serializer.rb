class LocationsSerializer < ActiveModel::Serializer
  attributes :id, :active, :admin_emails, :alternate_name, :coordinates,
             :description, :latitude, :longitude, :name, :short_desc, :slug,
             :website, :updated_at, :contacts_url, :services_url, :url

  has_one :address
  has_one :organization, serializer: LocationsOrganizationSerializer
  has_many :phones

  def contacts_url
    api_location_contacts_url(object)
  end

  def services_url
    api_location_services_url(object)
  end

  def url
    api_location_url(object)
  end
end
