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
    subdomain = SETTINGS[:api_subdomain] || ''
    subdomain += '.' unless subdomain.blank?
    domain = SETTINGS[:base_domain]
    path = SETTINGS[:api_path]
    domain += '/' unless path.blank?
    "http://#{subdomain}#{domain}#{path}/locations/#{slug}"
  end

  def accessibility
    object.accessibility.map(&:text)
  end

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end

  def include_associations!
    include! :address unless object.address.blank?
    include! :contacts unless object.contacts.blank?
    include! :faxes unless object.faxes.blank?
    include! :mail_address unless object.mail_address.blank?
    include! :phones unless object.phones.blank?
    include! :services unless object.services.blank?
    include! :organization
  end
end
