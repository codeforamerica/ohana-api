class EventsSerializer < ActiveModel::Serializer
  attributes :id, :title, :posted_at, :starting_at, :ending_at, :street_1,
             :street_2, :city, :state_abbr, :zip, :phone, :external_url,
             :organization_id, :is_featured, :body

  has_one :organization, serializer: LocationsOrganizationSerializer
  has_one :user, serializer: UserSerializer

  def posted_at
    object.posted_at.utc
  end

  def starting_at
    object.starting_at.utc
  end

  def ending_at
    object.ending_at.utc
  end
end
