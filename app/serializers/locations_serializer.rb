class LocationsSerializer < ActiveModel::Serializer
  attributes :id, :active, :admin_emails, :alternate_name, :coordinates,
             :description, :latitude, :longitude, :name, :short_desc, :slug,
             :website, :updated_at, :url

  has_one :address
  has_one :organization, serializer: LocationsOrganizationSerializer
  has_many :phones

  def coordinates
    return [] unless object.longitude.present? && object.latitude.present?
    [object.longitude, object.latitude]
  end

  def url
    api_location_url(object)
  end
end
