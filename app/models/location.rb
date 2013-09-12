class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Enumerize

  paginates_per Rails.env.test? ? 1 : 30

  attr_accessible :accessibility, :address, :ask_for, :contacts, :description,
                  :emails, :faxes, :hours, :kind, :languages, :mail_address,
                  :name, :phones, :short_desc, :transportation, :urls,
                  :contacts_attributes, :mail_address_attributes,
                  :address_attributes, :products, :payments, :market_match

  # embedded_in :organization
  belongs_to :organization
  validates_presence_of :organization

  # embeds_many :services
  has_many :services, dependent: :destroy
  #accepts_nested_attributes_for :services

  #has_many :contacts, dependent: :destroy
  embeds_many :contacts
  accepts_nested_attributes_for :contacts

  embeds_many :schedules
  accepts_nested_attributes_for :schedules

  # has_one :address
  # has_one :mail_address
  embeds_one :address
  embeds_one :mail_address
  accepts_nested_attributes_for :mail_address, :reject_if => :all_blank
  accepts_nested_attributes_for :address, :reject_if => :all_blank

  normalize_attributes :description, :hours, :name, :short_desc,
    :transportation, :urls

  field :accessibility
  enumerize :accessibility, in: [:cd, :deaf_interpreter, :disabled_parking,
    :elevator, :ramp, :restroom, :tape_braille, :tty, :wheelchair,
    :wheelchair_van], multiple: true

  field :ask_for, type: Array
  field :coordinates, type: Array
  field :description
  field :emails, type: Array
  field :faxes, type: Array
  field :hours

  field :kind
  enumerize :kind, in: [:other, :human_services, :entertainment, :farmers_market]

  field :languages, type: Array
  # enumerize :languages, in: [:arabic, :cantonese, :french, :german,
  #   :mandarin, :polish, :portuguese, :russian, :spanish, :tagalog, :urdu,
  #   :vietnamese,
  #    ], multiple: true

  field :name

  field :phones, type: Array

  field :short_desc
  field :transportation

  field :urls, type: Array

  # farmers markets
  field :market_match, type: Boolean
  field :products, type: Array
  field :payments, type: Array

  validates_presence_of :name
  validates_presence_of :description,
    :unless => Proc.new { |loc| loc.attributes.include?("market_match") }
  validate :address_presence

  extend ValidatesFormattingOf::ModelAdditions

  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: "Please enter a valid URL" } }

  validates :emails, array: {
    format: { with: /.+@.+\..+/i,
              message: "Please enter a valid email" } }

  validates :phones, hash:  {
    format: { with: /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/,
              allow_blank: true,
              message: "Please enter a valid US phone number" } }

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

  def full_physical_address
    if self.address.present?
      "#{self.address.street}, #{self.address.city}, #{self.address.state} "+
      "#{self.address.zip}"
    end
  end

  include Geocoder::Model::Mongoid
  geocoded_by :full_physical_address           # can also be an IP address

  # Only call Google's geocoding service if the address has changed
  # to avoid unnecessary requests that affect our rate limit.
  after_validation :geocode, if: :address_changed?

  #NE and SW geo coordinates that define the boundaries of San Mateo County
  SMC_BOUNDS = [[37.1074,-122.521], [37.7084,-122.085]].freeze

  ## ELASTICSEARCH
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # INDEX_NAME is defined in config/initializers/tire.rb
  index_name INDEX_NAME

  # Defines the JSON output of search results.
  # Since search returns locations, we also want to include
  # the location's parent organization info, as well as the
  # services that belong to the location. This allows clients
  # to get all this information in one query instead of three.
  def to_indexed_json
    hash = self.as_json(
      :except => [:organization_id],
        :methods => ['url', 'other_locations'],
      :include => {
        :services => { :except => [:location_id, :created_at],
          :methods => ['categories'] },
        :organization => { :methods => ['url', 'locations_url'] },
        :address => { :except => [:_id] },
        :mail_address => { :except => [:_id] },
        :contacts => { :except => [] }
      })
    hash.merge!("accessibility" => accessibility.map(&:text))
    hash.merge!("kind" => kind.text) if kind.present?
    remove_nil_fields(hash,["organization","contacts","services"])
    hash.to_json
  end

  # Removes nil fields from hash
  #
  # The main hash passed to the method is a JSON representation
  # of a Model including associated models (see to_indexed_json).
  # The fields passed are the associated models that contain
  # nil fields that we want to get rid of.
  # Each field is an Array of Hashes because it's a 1-N relationship:
  # Location embeds_many :contacts and has_many :services.
  # Once each associated model is cleaned up, we removed nil fields
  # from the main hash too.
  #
  # @param obj [Hash]
  # @param fields [Array] Array of strings
  # @return [Hash] The obj Hash with all nil fields stripped out
  def remove_nil_fields(obj,fields=[])
    fields.each do |field|
      if obj[field].is_a? Array
        obj[field].each { |h| h.reject! { |_,v| v.blank? } }
      elsif obj[field].is_a? Hash
        obj[field].reject! { |_,v| v.blank? }
      end
    end
    obj.reject! { |_,v| v.blank? }
  end

  mapping do
    indexes :coordinates, type: "geo_point"
    indexes :name, type: "string", analyzer: "standard"
    indexes :description, analyzer: "snowball"

    indexes :organization do
      indexes :name, type: 'string'
    end

    indexes :services do
      indexes :keywords, type: 'string', boost: 5, analyzer: "snowball"
      indexes :name, type: 'string', analyzer: "snowball"
      indexes :description, type: 'string', analyzer: "snowball"

      indexes :categories do
        indexes :name, type: 'string', boost: 10, analyzer: "snowball"
      end
    end

    # indexes :organization, type: 'object', properties: {
    #   name: { type: 'string' }
    # }
    # indexes :services, type: 'object', properties: {
    #   keywords: { type: 'string', boost: 5, analyzer: "snowball" },
    #   categories: { type: 'object', properties: { name: { type: 'string', boost: 10, analyzer: "snowball" } } },
    #   name: { type: 'string', analyzer: "snowball" },
    #   description: { type: 'string', analyzer: "snowball" }
    # }
  end

  def self.search(params={})
    # if params[:keyword].blank? && params[:location].blank? && params[:language].blank?
    # #   error!({
    # #     "error" => "bad request",
    # #     "description" => "Either keyword, location, or language is missing."
    # #   }, 400)
    # end

    # Google provides a "bounds" option to restrict the address search to
    # a particular area. Since this app focuses on organizations in San Mateo
    # County, we use SMC_BOUNDS to restrict the search.
    result = Geocoder.search(params[:location], :bounds => SMC_BOUNDS)
    # Google returns the coordinates as [lat, lon], but the geo_distance filter
    # below expects [lon, lat], so we need to reverse them.
    coords = result.first.coordinates.reverse if result.present?

    begin
    tire.search(page: params[:page], per_page: Rails.env.test? ? 1 : 30) do
      query do
        match [:name, :description, "organization.name", "services.keywords",
          "services.name", "services.description", "services.categories.name"],
          params[:keyword],
          type: 'phrase_prefix' if params[:keyword].present?
        match ["services.categories.name"], params[:category] if params[:category].present?
        filtered do
          filter :geo_distance, coordinates: coords, distance: "#{Location.current_radius(params[:radius])}miles" if params[:location].present?
          filter :term, :languages => params[:language].downcase if params[:language].present?
          filter :term, :kind => params[:kind].downcase if params[:kind].present?
          filter :not, { :terms => { :kind => ["market", "other"] } } if params[:exclude] == "market_other"
        end
      end
      sort do
        by :_geo_distance, :coordinates => coords, :unit => "mi", :order => "asc" if params[:location].present?
        by :created_at, "desc" if params[:keyword].blank? && params[:location].blank? && params[:language].blank?
      end
    end
    rescue Tire::Search::SearchRequestFailed
      error!({
        "error" => "bad request",
        "description" => "Invalid ZIP code or address."
      }, 400)
    end
  end

  def self.error!(message, status=403)
    throw :error, :message => message, :status => status
  end

  def self.current_radius(radius)
    if radius.present?
      begin
        radius = Float radius.to_s
        # radius must be between 0.1 miles and 10 miles
        [[0.1, radius].max, 10].min
      rescue ArgumentError
        error!({
        "error" => "bad request",
        "description" => "radius must be a number."
      }, 400)
      end
    else
      5
    end
  end

  def self.nearby(loc, params={})
    coords = loc.coordinates
    distance = params[:radius] ? Location.current_radius(params[:radius]) : 0.5
    if coords.present?
      tire.search(page: params[:page], per_page: Rails.env.test? ? 1 : 30) do
        query do
          filtered do
            filter :geo_distance, coordinates: coords, distance: "#{distance}miles"
            filter :not, { :ids => { :values => ["#{loc.id}"] } }
          end
        end
        sort do
          by :_geo_distance, :coordinates => coords, :unit => "mi", :order => "asc"
        end
      end
    else
      # If location has no coordinates, the search above will raise
      # an execption, so we return an empty array instead.
      []
    end
  end

  def address_presence
    unless address or mail_address
      errors[:base] << "A location must have at least one address type."
    end
  end

  def url
    "#{Rails.application.routes.url_helpers.root_url}locations/#{self.id}"
  end

  def other_locations
    other_locs = self.organization.locations
    coll = []
    other_locs.each { |loc| coll.push(loc.url) } if other_locs.size > 1
    coll
  end

  def physical_address_changed?
    self.address.changed? if self.address
  end

  def mail_address_changed?
    self.mail_address.changed? if self.mail_address
  end

  def address_changed?
    physical_address_changed? || mail_address_changed?
  end
end
