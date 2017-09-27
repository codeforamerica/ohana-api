class OrganizationSerializer < LocationsOrganizationSerializer
  has_many :contacts
  has_many :phones
  has_many :locations, serializer: LocationSerializer
  has_many :services, serializer: ServiceSerializer
end
