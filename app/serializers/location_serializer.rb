class LocationSerializer < ActiveModel::Serializer
  attributes :id, :active, :accessibility, :admin_emails, :alternate_name,
             :coordinates, :description, :email, :languages,
             :latitude, :longitude, :name, :short_desc, :slug, :transportation,
             :website, :updated_at, :url

  has_one :address
  has_many :contacts
  has_one :mail_address
  has_many :phones
  has_many :services
  has_many :regular_schedules
  has_many :holiday_schedules
  has_one :organization, serializer: SummarizedOrganizationSerializer

  def url
    api_location_url(object)
  end

  def accessibility
    object.accessibility.map(&:text)
  end
end
