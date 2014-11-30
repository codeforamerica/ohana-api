class LocationsOrganizationSerializer < ActiveModel::Serializer
  attributes :id, :accreditations, :alternate_name, :date_incorporated,
             :description, :email, :funding_sources, :licenses, :name,
             :website, :slug, :url, :locations_url

  def url
    api_organization_url(object)
  end

  def locations_url
    api_org_locations_url(object)
  end
end
