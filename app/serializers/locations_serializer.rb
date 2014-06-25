class LocationsSerializer < ActiveModel::Serializer
  attributes :id, :coordinates, :description, :latitude, :longitude, :name,
             :short_desc, :slug, :updated_at, :contacts_url, :faxes_url,
             :services_url, :url

  has_one :address
  has_one :organization
  has_many :phones

  def contacts_url
    "#{url}/contacts"
  end

  def faxes_url
    "#{url}/faxes"
  end

  def services_url
    "#{url}/services"
  end

  def url
    "#{url_prefix}/locations/#{slug}"
  end

  def url_prefix
    subdomain = ENV['API_SUBDOMAIN'] || ''
    subdomain += '.' unless subdomain.blank?
    domain = ENV['BASE_DOMAIN']
    path = ENV['API_PATH']
    domain += '/' unless path.blank?
    "http://#{subdomain}#{domain}#{path}"
  end
end
