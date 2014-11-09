class OrganizationSerializer < LocationsOrganizationSerializer
  has_many :contacts
  has_many :phones
end
