class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :website, :url, :locations_url

  def url
    api_organization_url(object)
  end

  def locations_url
    api_organization_locations_url(object)
  end
end
