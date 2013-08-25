class Service
  #include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps

  # embedded_in :location
  belongs_to :location
  validates_presence_of :location

  has_and_belongs_to_many :categories
  #belongs_to :category

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
  field :service_areas, type: Array
  field :short_desc
  field :urls, type: Array
  field :wait

  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: "Please enter a valid URL" } }
end