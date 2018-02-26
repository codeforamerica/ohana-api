class LocationSerializer < LocationsSerializer
  attributes :accessibility, :email, :hours, :languages, :market_match,
             :payments, :products, :transportation, :website

  has_many :contacts
  has_one :mail_address
  has_many :regular_schedules
  has_many :holiday_schedules
  has_many :services

  has_one :organization, serializer: SummarizedOrganizationSerializer

  def accessibility
    object.accessibility.map(&:text)
  end

  def include_payments?
    object.kind == 'farmers_markets'
  end

  def include_products?
    object.kind == 'farmers_markets'
  end

  def include_market_match?
    object.kind == 'farmers_markets'
  end
end
