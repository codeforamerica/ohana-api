class Organization
  include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps

  include Tire::Model::Search
  include Tire::Model::Callbacks

  # INDEX_NAME is defined in config/initializers/bonsai.rb
  index_name INDEX_NAME

  # This is required by the "tire" ElasticSearch gem
  def to_indexed_json
    self.to_json
  end

  mapping do
    indexes :agency
    indexes :name
    indexes :description
    indexes :keywords, boost: 5
    indexes :coordinates, type: 'geo_point'
  end

  # NE and SW geo coordinates that define the boundaries of San Mateo County
  # Replace the coordinates if setting up the API for another location.
  SMC_BOUNDS = [[37.1074,-122.521], [37.7084,-122.085]].freeze

  def self.search(params={})
    if params[:keyword].blank? && params[:location].blank? && params[:language].blank?
      error_message("no_params")
    end

    # Google provides a "bounds" option to restrict the address search to
    # a particular area. Since this app focuses on organizations in San Mateo
    # County, we use SMC_BOUNDS to restrict the search.
    result = Geocoder.search(params[:location], :bounds => SMC_BOUNDS)
    # Google returns the coordinates as [lat, lon], but the geo_distance filter
    # below expects [lon, lat], so we need to reverse them.
    coords = result.first.coordinates.reverse if result.present?

    begin
    tire.search(page: params[:page], per_page: 30) do
      query do
        match [:name, :agency, :description, :keywords], params[:keyword], type: 'phrase_prefix' if params[:keyword].present?
        filtered do
          filter :geo_distance, coordinates: coords, distance: "#{Organization.current_radius(params[:radius])}miles" if params[:location].present?
          filter :term, :languages_spoken => params[:language].downcase if params[:language].present?
        end
      end
      sort do
        by :_geo_distance, :coordinates => coords, :unit => "mi", :order => "asc" if params[:location].present?
      end
    end
    rescue Tire::Search::SearchRequestFailed
      error_message("invalid_location")
    end
  end

  def self.current_radius(radius)
    if radius.present?
      begin
        radius = Float radius.to_s
        # radius must be between 0.1 miles and 10 miles
        [[0.1, radius].max, 10].min
      rescue ArgumentError
        error_message("invalid_radius")
      end
    else
      5
    end
  end

  def self.nearby(org, params={})
    coords = org.coordinates
    tire.search(page: params[:page], per_page: 30) do
      query do
        filtered do
          filter :geo_distance, coordinates: coords, distance: "#{Organization.current_radius(params[:radius])}miles"
          filter :not, { :ids => { :values => ["#{org.id}"] } }
        end
      end
      sort do
        by :_geo_distance, :coordinates => coords, :unit => "mi", :order => "asc"
      end
    end
  end

  #combines address fields together into one string
  def address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  def self.error_message(type)
    error = RocketPants::BadRequest.new
    if type == "no_params"
      error.context =
        { metadata:
          { :specific_reason =>
            "Either keyword, location, or language is missing." } }
    elsif type == "invalid_location"
      error.context =
        { metadata: { :specific_reason => "Invalid ZIP code or address." } }
    elsif type == "invalid_radius"
      error.context =
        { metadata: { :specific_reason => "radius must be a number." } }
    end
    raise error
  end

  normalize_attributes :agency, :city, :description, :eligibility_requirements,
    :fees, :how_to_apply, :name, :service_hours, :service_wait,
    :services_provided, :street_address, :target_group,
    :transportation_availability, :zipcode

  field :accessibility_options, type: Array
  field :agency, type: String
  field :ask_for, type: Array
  field :city, type: String
  field :coordinates, type: Array
  field :description, type: String
  field :eligibility_requirements, type: String
  field :emails, type: Array
  field :faxes, type: Array
  field :fees, type: String
  field :funding_sources, type: Array
  field :how_to_apply, type: String
  field :keywords, type: Array
  field :languages_spoken, type: Array
  field :leaders, type: Array
  field :market_match, type: Boolean
  field :name, type: String
  field :payments_accepted, type: Array
  field :phones, type: Array
  field :products_sold, type: Array
  field :service_areas, type: Array
  field :service_hours, type: String
  field :service_wait, type: String
  field :services_provided, type: String
  field :state, type: String
  field :street_address, type: String
  field :target_group, type: String
  field :transportation_availability, type: String
  field :ttys, type: Array
  field :urls, type: Array
  field :zipcode, type: String

  validates_presence_of :name

  extend ValidatesFormattingOf::ModelAdditions
  validates_formatting_of :zipcode, using: :us_zip,
                            allow_blank: true,
                            message: "%{value} is not a valid ZIP code"

  validates :phones, hash:  {
    format: { with: /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/,
              allow_blank: true,
              message: "Please enter a valid US phone number" } }

  validates :emails, array: {
    format: { with: /.+@.+\..+/i,
              message: "Please enter a valid email" } }

  validates :urls, array: {
    format: { with: /(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/i,
              message: "Please enter a valid URL" } }

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  #after_validation :geocode          # auto-fetch coordinates

end
