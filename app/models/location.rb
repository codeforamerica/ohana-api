class Location
  include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps
  #extend Enumerize

  belongs_to :organization
  has_and_belongs_to_many :languages

  normalize_attributes :name, :description, :fax, :email, :hours, :street,
    :po_box, :city, :state, :zipcode

  field :name
  field :description
  field :phones, type: Array
  field :faxes, type: Array
  field :emails, type: Array
  field :hours
  field :urls, type: Array

  # Address fields
  field :street
  field :po_box
  field :city
  field :state
  field :zipcode
  field :coordinates, type: Array

  field :keywords, type: Array
  field :payments_accepted, type: Array
  field :products_sold, type: Array

  # field :languages
  # enumerize :languages, in: [:french, :english, :vietnamese,
  #   :polish, :german, :russian, :mandarin, :tagalog, :arabic,
  #   :urdu, :chinese_cantonese], multiple: true

  validates_presence_of :name, :city, :zipcode

  extend ValidatesFormattingOf::ModelAdditions
  validates_formatting_of :zipcode, using: :us_zip,
                            allow_blank: true,
                            message: "%{value} is not a valid ZIP code"

  validates :emails, array: {
    format: { with: /.+@.+\..+/i,
              message: "Please enter a valid email" } }

  validates :phones, hash:  {
    format: { with: /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/,
              allow_blank: true,
              message: "Please enter a valid US phone number" } }

  validates :urls, array: {
    format: { with: /(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/i,
              message: "Please enter a valid URL" } }

  def self.find_by_keyword(keyword)
    orgs = Organization.full_text_search(keyword)
    Location.where(:organization_id.in => orgs.map(&:id))
  end

  #combines address fields together into one string
  def address
    "#{self.street}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  #after_validation :geocode          # auto-fetch coordinates

  #NE and SW geo coordinates that define the boundaries of San Mateo County
  SMC_BOUNDS = [[37.1074,-122.521], [37.7084,-122.085]].freeze

  # Google provides a "bounds" option to restrict the address search to
  # a particular area. Since this app focues on organizations in San Mateo
  # County, we use SMC_BOUNDS to restrict the search.
  def self.find_near(location, radius)
    result = Geocoder.search(location, :bounds => SMC_BOUNDS)
    coords = result.first.coordinates if result.present?
    near(coords, radius)
  end
end
