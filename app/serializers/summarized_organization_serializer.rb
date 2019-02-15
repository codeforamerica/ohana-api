class SummarizedOrganizationSerializer < ActiveModel::Serializer

  attributes :id, :alternate_name, :name, :slug, :website, :twitter, :facebook,
             :linkedin, :logo_url

  def url
    api_organization_url(object)
  end
end
