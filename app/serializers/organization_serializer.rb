class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :url, :locations_url

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end

  def url
    "http://#{prefix}/organizations/#{slug}"
  end

  def locations_url
    "http://#{prefix}/organizations/#{slug}/locations"
  end

  def prefix
    subdomain = SETTINGS[:api_subdomain] || ''
    subdomain += '.' unless subdomain.blank?
    domain = SETTINGS[:base_domain]
    path = SETTINGS[:api_path]
    domain += '/' unless path.blank?
    "#{subdomain}#{domain}#{path}"
  end
end
