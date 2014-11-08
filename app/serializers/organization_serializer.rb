class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :accreditations, :alternate_name, :date_incorporated,
             :description, :email, :funding_sources, :licenses, :name, :slug,
             :website, :url, :locations_url

  has_many :contacts
  has_many :phones

  def url
    api_organization_url(object)
  end

  def locations_url
    api_org_locations_url(object)
  end
end
