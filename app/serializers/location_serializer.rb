class LocationSerializer < ActiveModel::Serializer
  attributes :id, :accessibility, :admin_emails, :coordinates, :description,
             :emails, :hours, :languages, :latitude, :longitude, :name,
             :short_desc, :slug, :transportation, :updated_at, :urls, :url

  has_one :address
  has_many :contacts
  has_many :faxes
  has_one :mail_address
  has_many :phones
  has_many :services
  has_one :organization

  def url
    subdomain = ENV['API_SUBDOMAIN'] || ''
    subdomain += '.' unless subdomain.blank?
    domain = ENV['BASE_DOMAIN']
    path = ENV['API_PATH']
    domain += '/' unless path.blank?
    "http://#{subdomain}#{domain}#{path}/locations/#{slug}"
  end

  def accessibility
    object.accessibility.map(&:text)
  end
end
