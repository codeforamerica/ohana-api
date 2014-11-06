class LocationSerializer < ActiveModel::Serializer
  attributes :id, :active, :accessibility, :admin_emails, :alternate_name,
             :coordinates, :description, :emails, :languages,
             :latitude, :longitude, :name, :short_desc, :slug, :transportation,
             :updated_at, :urls, :url

  has_one :address
  has_many :contacts
  has_one :mail_address
  has_many :phones
  has_many :services
  has_many :regular_schedules
  has_many :holiday_schedules
  has_one :organization

  def url
    api_location_url(object)
  end

  def accessibility
    object.accessibility.map(&:text)
  end
end
