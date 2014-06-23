class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :url, :locations_url

  def attributes
    hash = super
    hash.delete_if { |_, v| v.blank? }
  end

  def url
    "#{url_prefix}/organizations/#{slug}"
  end

  def locations_url
    "#{url}/locations"
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
