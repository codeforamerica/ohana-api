class EventsSerializer < ActiveModel::Serializer
  attributes :title, :posted_at, :starting_at, :ending_at, :street_1,
             :street_2, :city, :state_abbr, :zip, :phone, :external_url,
             :organization_id, :is_featured, :body

  has_one :organization, serializer: LocationsOrganizationSerializer
  has_one :admin, serializer: AdminSerializer
end
