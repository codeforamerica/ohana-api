class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :alternate_name, :date_incorporated, :description, :email,
             :name, :slug, :website, :url, :locations_url

  def url
    api_organization_url(object)
  end

  def locations_url
    api_org_locations_url(object)
  end
end
