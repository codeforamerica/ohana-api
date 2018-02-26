class LocationsSerializer < ActiveModel::Serializer
  attributes :id, :active, :admin_emails, :alternate_name, :coordinates,
             :description, :kind, :latitude, :longitude, :name, :short_desc,
             :slug, :updated_at, :url

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

  def kind
    object.kind.text
  end
end
