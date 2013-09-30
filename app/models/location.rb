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
    :transportation, :urls, :kind

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
  # Don't change the terms here! You can change their display
  # name in config/locales/en.yml
  enumerize :kind, in: [:arts, :clinics, :entertainment, :farmers_markets,
    :government, :human_services, :libraries, :museums, :other, :parks, :sports,
    :test]

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
    indexes :address do
      indexes :zip, index: "analyzed"
      indexes :city, index: "not_analyzed"
    end
    indexes :name, type: "multi_field",
      fields: {
        name:  { type: "string", index: "analyzed", analyzer: "snowball" },
        exact: { type: "string", index: "not_analyzed" }
      }
    indexes :description, analyzer: "snowball"
    indexes :products, :index => :not_analyzed
    indexes :kind, type: "string", analyzer: "keyword"

    indexes :organization do
      indexes :name, type: "multi_field",
        fields: {
          name:  { type: "string", index: "analyzed", analyzer: "snowball" },
          exact: { type: "string", index: "not_analyzed" }
        }
    end

    indexes :services do
      indexes :categories do
        indexes :name, type: "multi_field",
          fields: {
            name: { type: "string", index: "analyzed", analyzer: "snowball" },
            exact: { type: "string", index: "not_analyzed" }
          }
      end
      indexes :keywords, type: "multi_field",
        fields: {
          keywords: { type: "string", index: "analyzed", analyzer: "snowball" },
          exact: { type: "string", index: "not_analyzed" }
        }
      indexes :name, type: 'string', analyzer: "snowball"
      indexes :description, type: 'string', analyzer: "snowball"
      indexes :service_areas, index: "not_analyzed"
    end
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
    result = Geocoder.search(params[:location], :bounds => SMC_BOUNDS) if params[:location].present?
    # Google returns the coordinates as [lat, lon], but the geo_distance filter
    # below expects [lon, lat], so we need to reverse them.
    coords = result.first.coordinates.reverse if result.present?

    begin
    tire.search(page: params[:page], per_page: Rails.env.test? ? 1 : 30) do
      query do
        if params[:keyword].present?
          custom_filters_score do
            query do
              boolean do
                must do
                  match [:name, :description, "organization.name",
                    "services.keywords", "services.name", "services.description",
                    "services.categories.name"], params[:keyword]
                end
                should do
                  term "name.exact", params[:keyword], boost: 30
                  prefix "name.exact", params[:keyword], boost: 5
                  term "services.keywords.exact", params[:keyword], boost: 20
                  term "services.categories.name.exact", params[:keyword], boost: 20
                  match [:name, :description, "organization.name",
                    "services.keywords", "services.name", "services.description",
                    "services.categories.name"], params[:keyword], slop: 0, boost: 15, type: "phrase"
                end
              end
            end
            if params[:location].present?
              filter do
                filter :term,
                  "address.city" => params[:location].
                                      split(",")[0].gsub("+"," ").titleize
                boost 50
              end
              filter do
                filter :term, "address.zip" => params[:location]
                boost 50
              end
            end
            filter do
              filter :term, kind: "Human Services"
              boost 25
            end
            filter do
              filter :term, "organization.name.exact" => "San Mateo County Human Services Agency"
              boost 30
            end
            # filter do
            #   filter :geo_distance_range, :from => "0mi", :to => "5mi", :coordinates => coords
            #   boost 30
            # end
            score_mode "total"
          end
        end
        #match ["services.categories.name.name"], :default_operator => 'AND' if params[:category].present?
        filtered do
          filter :geo_distance, coordinates: coords, distance: "#{Location.current_radius(params[:radius])}miles" if params[:location].present?
          #filter :geo_bounding_box, :coordinates => { :top_left => "37.7084,-122.521", :bottom_right => "37.1066,-122.08" }
          filter :term, :languages => params[:language].downcase if params[:language].present?
          filter :terms, :kind => params[:kind].map(&:titleize) if params[:kind].present?
          filter :not, {
            :terms => {
              :kind => ["Arts", "Entertainment", "Farmers' Markets",
                "Government", "Libraries", "Museums", "Other", "Parks",
                "Sports", "Test"] } } if params[:exclude] == "market_other"
          filter :not, { :term => { :kind => "Other" } } if params[:exclude] == "Other"
          filter :exists, field: 'market_match' if params[:market_match] == "1"
          filter :missing, field: 'market_match' if params[:market_match] == "0"
          filter :term, :payments => params[:payments].downcase if params[:payments].present?
          filter :term, :products => params[:products].titleize if params[:products].present?
          filter :not, { :term => { :kind => "Test" } } if params[:keyword] != "maceo"
          filter :term, "services.categories.name.exact" => params[:category] if params[:category].present?
          filter :term, "organization.name.exact" => params[:org_name] if params[:org_name].present?
          filter :terms, "services.service_areas" => Location.smc_service_areas if params[:service_area] == "smc"
        end
      end
      sort do
        by :_geo_distance, :coordinates => coords, :unit => "mi", :order => "asc" if params[:location].present?
        if params[:sort] == "kind"
          by :kind, params[:order] == "desc" ? "desc" : "asc"
        end
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
        # radius must be between 0.1 miles and 50 miles
        [[0.1, radius].max, 50].min
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

  def self.smc_service_areas
    [
      'San Mateo County','Atherton','Belmont','Brisbane','Burlingame','Colma',
      'Daly City','East Palo Alto','Foster City','Half Moon Bay',
      'Hillsborough','Menlo Park','Millbrae','Pacifica','Portola Valley',
      'Redwood City','San Bruno','San Carlos','San Mateo',
      'South San Francisco','Woodside','Broadmoor','Burlingame Hills',
      'Devonshire','El Granada','Emerald Lake Hills','Highlands-Baywood Park',
      'Kings Mountain','Ladera','La Honda','Loma Mar','Menlo Oaks','Montara',
      'Moss Beach','North Fair Oaks','Palomar Park','Pescadero',
      'Princeton-by-the-Sea','San Gregorio','Sky Londa','West Menlo Park'
    ]
  end
end
