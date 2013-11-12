class Service
  #include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps
  include Grape::Entity::DSL

  # embedded_in :location
  belongs_to :location
  validates_presence_of :location

  has_and_belongs_to_many :categories
  #belongs_to :category

  embeds_many :schedules
  accepts_nested_attributes_for :schedules
  #accepts_nested_attributes_for :categories

  attr_accessible :audience, :description, :eligibility, :fees,
    :funding_sources, :keywords, :how_to_apply, :name, :service_areas,
    :short_desc, :urls, :wait

  normalize_attributes :audience, :description, :eligibility, :fees,
    :how_to_apply, :name, :short_desc, :wait

  field :audience
  field :description
  field :eligibility
  field :fees
  field :funding_sources, type: Array
  field :keywords, type: Array
  field :how_to_apply
  field :name
  field :service_areas, type: Array, default: []
  field :short_desc
  field :urls, type: Array
  field :wait

  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: "Please enter a valid URL" } }

  validate :service_area_format, :keyword_format

  def service_area_format
    if service_areas.is_a?(String)
      errors[:base] << "Service areas must be an array."
    else
      unless (service_areas - valid_service_areas).size == 0
        errors[:base] << "At least one service area is improperly formatted,
          or is not an accepted city or county name. Please make sure all
          words are capitalized."
      end
    end
  end

  def keyword_format
    if keywords.is_a?(String)
      errors[:base] << "Keywords must be an array."
    end
  end

  def valid_service_areas
    [
      "Alameda County", "Alaska", "Almaden Valley", "Alum Rock", "Alviso",
      "Arizona", "Atherton", "Belmont", "Berryessa", "Brisbane",
      "British Columbia", "Broadmoor", "Burlingame", "Calaveras County",
      "California", "California statewide", "Campbell", "Canada",
      "Castro Valley", "Central California", "Central San Mateo County",
      "Colma", "Contra Costa County", "Coyote",
      "Cupertino", "Daly City", "Del Norte County", "Dublin",
      "East Menlo Park", "East Palo Alto", "El Granada", "Evergreen",
      "Fairfield", "Foster City", "Fremont", "Fresno", "Fresno County",
      "Gilroy", "Guam", "Half Moon Bay", "Hawaii", "Hayward", "Hillsborough",
      "Humboldt County", "Idaho", "Inyo", "Japan", "Kern County",
      "Kings County", "La Honda", "Lake County", "Loma Mar", "Los Altos",
      "Los Altos Hills", "Los Angeles County", "Los Gatos", "Madera County",
      "Marin County", "Mendocino County", "Menlo Park", "Merced County",
      "Millbrae", "Milpitas", "Miramar", "Montara", "Monte Sereno",
      "Monte Vista", "Monterey", "Monterey County", "Morgan Hill",
      "Moss Beach", "Mountain View", "Napa County", "Nevada", "Newark",
      "North Fair Oaks", "North Santa Clara County", "Northern California",
      "Northern San Mateo County", "Northern Santa Clara County",
      "Orange County", "Oregon", "Pacifica", "Palo Alto", "Pescadero",
      "Placer County", "Pleasanton", "Portola Valley", "Princeton",
      "Redwood City", "Redwood Shores", "Sacramento", "Sacramento County",
      "San Benito County", "San Bruno", "San Carlos", "San Francisco County",
      "San Gregorio", "San Joaquin County", "San Jose", "San Leandro",
      "San Lorenzo", "San Luis Obispo", "San Luis Obispo County", "San Martin",
      "San Mateo", "San Mateo County", "San Mateo County (unincorporated)",
      "San Ramon", "Santa Clara", "Santa Clara County", "Santa Cruz County",
      "Saratoga", "Silver Creek", "Siskiyou County", "Solano County",
      "Sonoma County", "South San Francisco", "Stanford", "Stanislaus County",
      "Statewide", "Sunnyvale", "Sutter County", "Trinity County",
      "Tulare County", "Tunitas", "Tuolumne County", "Union City", "Utah",
      "Washington", "West San Jose", "Willow Glen", "Woodside", "Yolo",
      "Yolo County", "Yuba", "East San Jose", "nationwide",
      "Northern California", "Statewide", "Unincorporated San Mateo County",
      "Western U.S.", "Western United States", "Worldwide"
    ]
  end

  entity do
    expose              :id
    expose        :audience, :unless => lambda { |o,_| o.audience.blank? }
    expose     :description, :unless => lambda { |o,_| o.description.blank? }
    expose     :eligibility, :unless => lambda { |o,_| o.eligibility.blank? }
    expose            :fees, :unless => lambda { |o,_| o.fees.blank? }
    expose :funding_sources, :unless => lambda { |o,_| o.funding_sources.blank? }
    expose        :keywords, :unless => lambda { |o,_| o.keywords.blank? }
    expose      :categories, :using => Category::Entity, :unless => lambda { |o,_| o.categories.blank? }
    #expose      :categories, :unless => lambda { |o,_| o.categories.blank? }
    expose    :how_to_apply, :unless => lambda { |o,_| o.how_to_apply.blank? }
    expose            :name, :unless => lambda { |o,_| o.name.blank? }
    expose   :service_areas, :unless => lambda { |o,_| o.service_areas.blank? }
    expose      :short_desc, :unless => lambda { |o,_| o.short_desc.blank? }
    expose            :urls, :unless => lambda { |o,_| o.urls.blank? }
    expose            :wait, :unless => lambda { |o,_| o.wait.blank? }
    expose      :updated_at
  end
end