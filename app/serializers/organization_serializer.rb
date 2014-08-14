class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :_slugs, :slugs, :urls, :url, :locations_url

  def url
    api_organization_url(object)
  end

  def locations_url
    api_organization_locations_url(object)
  end

  # Remove once the Postgres migration is done and smc-connect has been updated
  def _slugs
    [slug]
  end

  def slugs
    [slug]
  end
end
