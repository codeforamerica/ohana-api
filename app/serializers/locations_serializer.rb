class LocationsSerializer < ActiveModel::Serializer
  attributes :id, :admin_emails, :coordinates, :description, :kind, :latitude,
             :longitude, :market_match, :name, :short_desc, :slug, :slugs,
             :updated_at, :urls, :contacts_url, :faxes_url, :services_url, :url

  has_one :address
  has_one :organization
  has_many :phones

  def contacts_url
    api_location_contacts_url(object)
  end

  def faxes_url
    api_location_faxes_url(object)
  end

  def services_url
    api_location_services_url(object)
  end

  def url
    api_location_url(object)
  end

  def coordinates
    return [] unless object.longitude.present? && object.latitude.present?
    [object.longitude, object.latitude]
  end

  def kind
    object.kind.text
  end

  def include_market_match?
    object.kind == 'farmers_markets'
  end

  # Remove once the Postgres migration is done and smc-connect has been updated
  def slugs
    [slug]
  end
end
