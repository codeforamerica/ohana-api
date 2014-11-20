class SummarizedOrganizationSerializer < ActiveModel::Serializer
  attributes :id, :alternate_name, :name, :slug, :url

  def url
    api_organization_url(object)
  end
end
