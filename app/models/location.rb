class Location
  include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Enumerize

  # embedded_in :program
  belongs_to :program
  validate :address_presence
  validates_presence_of :program

  # has_one :address
  # has_one :mail_address

  embeds_one :address
  embeds_one :mail_address
  accepts_nested_attributes_for :mail_address, :reject_if => :all_blank
  accepts_nested_attributes_for :address, :reject_if => :all_blank

  #has_many :contacts, dependent: :destroy

  normalize_attributes :hours, :wait, :transportation

  field :program_name
  field :hours
  field :wait
  field :transportation

  field :ask_for, type: Array
  field :coordinates, type: Array
  field :emails, type: Array
  field :faxes, type: Array
  field :keywords, type: Array
  field :phones, type: Array
  field :service_areas, type: Array

  # farmers' markets and stores
  field :payments_accepted, type: Array
  field :products_sold, type: Array

  field :languages, type: Array
  # enumerize :languages, in: [:arabic, :cantonese, :french, :german,
  #   :mandarin, :polish, :portuguese, :russian, :spanish, :tagalog, :urdu,
  #   :vietnamese,
  #    ], multiple: true

  field :accessibility
  enumerize :accessibility, in: [:cd, :deaf_interpreter, :disabled_parking,
    :elevator, :ramp, :restroom, :tape_braille, :tty, :wheelchair,
    :wheelchair_van], multiple: true

  validates :emails, array: {
    format: { with: /.+@.+\..+/i,
              message: "Please enter a valid email" } }

  validates :phones, hash:  {
    format: { with: /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/,
              allow_blank: true,
              message: "Please enter a valid US phone number" } }

  def self.find_by_keyword(keyword)
    progs = Program.full_text_search(keyword)
    Location.where(:program_id.in => progs.map(&:id))
  end

  #combines address fields together into one string
  def full_address
    if self.address.present?
      "#{self.address.street}, #{self.address.city}, #{self.address.state} "+
      "#{self.address.zip}"
    elsif self.mail_address.present? && self.address.blank?
      "#{self.mail_address.street}, #{self.mail_address.city}, "+
      "#{self.mail_address.state} #{self.mail_address.zip}"
    end
  end

  include Geocoder::Model::Mongoid
  geocoded_by :full_address           # can also be an IP address
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

  def address_presence
    unless address or mail_address
      errors[:base] << "A location must have at least one address type."
    end
  end
end
