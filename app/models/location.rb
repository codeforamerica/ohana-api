class Location < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :address_street],
      [:name, :mail_address_city]
    ]
  end

  def address_street
    address.street if address.present?
  end

  def mail_address_city
    mail_address.city if mail_address.present?
  end

  extend Enumerize
  serialize :accessibility, Array
  # Don't change the terms here! You can change their display
  # name in config/locales/en.yml
  enumerize(
    :accessibility,
    in: [
      :cd, :deaf_interpreter, :disabled_parking,
      :elevator, :ramp, :restroom, :tape_braille, :tty, :wheelchair,
      :wheelchair_van
    ],
    multiple: true,
    scope: true
  )

  # List of admin emails that should have access to edit a location's info.
  # Admin emails can be added to a location via the Admin GUI:
  # https://github.com/codeforamerica/ohana-api-admin
  serialize :admin_emails, Array

  serialize :emails, Array

  serialize :languages, Array
  # enumerize :languages, in: [:arabic, :cantonese, :french, :german,
  #   :mandarin, :polish, :portuguese, :russian, :spanish, :tagalog, :urdu,
  #   :vietnamese,
  #    ], multiple: true, scope: true

  serialize :urls, Array

  attr_accessible :accessibility, :address, :admin_emails, :contacts,
                  :description, :emails, :faxes, :hours, :languages,
                  :latitude, :longitude, :mail_address, :name, :phones,
                  :short_desc, :transportation, :urls, :address_attributes,
                  :contacts_attributes, :faxes_attributes,
                  :mail_address_attributes, :phones_attributes,
                  :services_attributes, :organization_id

  belongs_to :organization, touch: true

  has_one :address, dependent: :destroy
  validates_presence_of(
    :address,
    message: 'A location must have at least one address type.',
    unless: proc { |loc| loc.mail_address.present? }
  )
  accepts_nested_attributes_for :address, allow_destroy: true

  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts

  has_many :faxes, dependent: :destroy
  accepts_nested_attributes_for :faxes

  has_one :mail_address, dependent: :destroy
  validates_presence_of(
    :mail_address,
    message: 'A location must have at least one address type.',
    unless: proc { |loc| loc.address.present? }
  )
  accepts_nested_attributes_for :mail_address, allow_destroy: true

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones

  has_many :services, dependent: :destroy
  accepts_nested_attributes_for :services

  # has_many :schedules, dependent: :destroy
  # accepts_nested_attributes_for :schedules

  normalize_attributes :description, :hours, :name,
                       :short_desc, :transportation, :urls

  # This is where you define all the fields that you want to be required
  # when uploading a dataset or creating a new entry via an admin interface.
  # You can separate the required fields with a comma. For example:
  # validates_presence_of :name, :hours, :phones

  validates_presence_of :description, :organization, :name,
                        message: "can't be blank for Location"

  ## Uncomment the line below if you want to require a short description.
  ## We recommend having a short description so that web clients can display
  ## an overview within the search results. See smc-connect.org as an example.
  # validates_presence_of :short_desc

  ## Uncomment the line below if you want to limit the
  ## short description's length. If you want to display a short description
  ## on a front-end client like smc-connect.org, we recommmend writing or
  ## re-writing a description that's one to two sentences long, with a
  ## maximum of 200 characters. This is just a recommendation though.
  ## Feel free to modify the maximum below, and the way the description is
  ## displayed in the ohana-web-search client to suit your needs.
  # validates_length_of :short_desc, :maximum => 200

  # These are custom validations for values within arrays and hashes.
  # For example, the faxes field is an array that can contain multiple faxes.
  # To be able to validate each fax number in the array, we have to use a
  # custom array validator.
  # Both custom validators are defined in app/validators/
  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: '%{value} is not a valid URL' } }

  validates :emails, array: {
    format: { with: /.+@.+\..+/i,
              allow_blank: true,
              message: '%{value} is not a valid email' } }

  validate :format_of_admin_email

  def format_of_admin_email
    regexp = /.+@.+\..+/i
    if admin_emails.present? &&
        (!admin_emails.is_a?(Array) || admin_emails.find { |a| a.match(regexp).nil? })
      errors[:base] << 'admin_emails must be an array of valid email addresses'
    end
  end

  def full_physical_address
    if address.present?
      "#{address.street}, #{address.city}, #{address.state} " \
      "#{address.zip}"
    end
  end

  def coordinates
    [longitude, latitude] if longitude.present? && latitude.present?
  end

  after_validation :reset_coordinates, if: :address_blank?

  def address_blank?
    address.blank?
  end

  def reset_coordinates
    self.latitude = nil
    self.longitude = nil
  end

  geocoded_by :full_physical_address           # can also be an IP address

  # Only call Google's geocoding service if the address has changed
  # to avoid unnecessary requests that affect our rate limit.
  after_validation :geocode, if: :needs_geocoding?

  def needs_geocoding?
    address.changed? || latitude.nil? || longitude.nil? if address.present?
  end

  # NE and SW geo coordinates that define the boundaries of San Mateo County
  SMC_BOUNDS = [[37.1074, -122.521], [37.7084, -122.085]].freeze

  ## ELASTICSEARCH
  include Tire::Model::Search

  after_save :update_tire_index
  after_destroy :update_tire_index
  after_touch :update_tire_index

  def update_tire_index
    tire.update_index
  end

  # paginates_per Rails.env.test? ? 1 : 30

  # INDEX_NAME is defined in config/initializers/tire.rb
  index_name INDEX_NAME

  # Defines the JSON output of search results.
  # Since search returns locations, we also want to include
  # the location's parent organization info, as well as the
  # services that belong to the location. This allows clients
  # to get all this information in one query instead of three.
  def to_indexed_json
    hash = as_json(
      except: [:organization_id],
      methods: ['url'],
      include: {
        services: {
          except: [:location_id, :created_at],
          include: {
            categories: {
              except: [:ancestry, :created_at, :updated_at],
              methods: ['depth']
            }
          }
        },
        organization: { methods: %w(url locations_url) },
        address: { except: [:created_at, :updated_at] },
        mail_address: { except: [:created_at, :updated_at] },
        contacts: { except: [:created_at, :updated_at] },
        faxes: { except: [:created_at, :updated_at] },
        phones: { except: [:created_at, :updated_at] }
      },
      methods: %w(coordinates url)
    )
    hash.merge!('accessibility' => accessibility.map(&:text))
    remove_nil_fields(hash, %w(organization contacts faxes phones services))
    hash.to_json
  end

  # Removes nil fields from hash
  #
  # The main hash passed to the method is a JSON representation
  # of a Model including associated models (see to_indexed_json).
  # The fields passed are the associated models that contain
  # nil fields that we want to get rid of.
  # Each field is an Array of Hashes because it's a 1-N relationship:
  # Location has_many :contacts and has_many :services.
  # Once each associated model is cleaned up,  we removed nil fields
  # from the main hash too.
  #
  # @param obj [Hash]
  # @param fields [Array] Array of strings
  # @return [Hash] The obj Hash with all nil fields stripped out
  def remove_nil_fields(obj, fields = [])
    fields.each do |field|
      if obj[field].is_a? Array
        obj[field].each { |h| h.reject! { |_, v| v.blank? } }
      elsif obj[field].is_a? Hash
        obj[field].reject! { |_, v| v.blank? }
      end
    end
    obj.reject! { |_, v| v.blank? }
  end

  settings(
    number_of_shards: 1,
    number_of_replicas: 1,
    analysis: {
      tokenizer: {
        extract_url_domain: {
          'pattern'   => '(http|https):\/\/(www.)?([^\/]+)',
          'group'     => '3',
          'type'      => 'pattern'
        },
        extract_email_domain: {
          'pattern'   => '.+@(.+)',
          'group'     => '1',
          'type'      => 'pattern'
        }
      },
      analyzer: {
        url_analyzer: {
          'tokenizer' => 'extract_url_domain',
          'type' => 'custom'
        },
        email_analyzer: {
          'tokenizer' => 'extract_email_domain',
          'type' => 'custom'
        }
      }
    }
  ) do

    mapping do
      indexes :coordinates, type: 'geo_point'
      indexes :address do
        indexes :zip, index: 'analyzed'
        indexes :city, index: 'not_analyzed'
      end
      indexes :name,
              type: 'multi_field',
              fields: {
                name:  { type: 'string', index: 'analyzed', analyzer: 'snowball' },
                exact: { type: 'string', index: 'not_analyzed' }
              }
      indexes :description, analyzer: 'snowball'
      indexes :emails,
              type: 'multi_field',
              fields: {
                exact:  { type: 'string', index: 'not_analyzed' },
                domain: { type: 'string', index_analyzer: 'email_analyzer', search_analyzer: 'keyword' }
              }
      indexes :admin_emails, index: 'not_analyzed'
      indexes :urls, type: 'string', index_analyzer: 'url_analyzer', search_analyzer: 'keyword'

      indexes :organization do
        indexes :name,
                type: 'multi_field',
                fields: {
                  name:  { type: 'string', index: 'analyzed', analyzer: 'snowball' },
                  exact: { type: 'string', index: 'not_analyzed' }
                }
      end

      indexes :services do
        indexes :categories do
          indexes :name,
                  type: 'multi_field',
                  fields: {
                    name: { type: 'string', index: 'analyzed', analyzer: 'snowball' },
                    exact: { type: 'string', index: 'not_analyzed' }
                  }
        end
        indexes :keywords,
                type: 'multi_field',
                fields: {
                  keywords: { type: 'string', index: 'analyzed', analyzer: 'snowball' },
                  exact: { type: 'string', index: 'not_analyzed' }
                }
        indexes :name, type: 'string', analyzer: 'snowball'
        indexes :description, type: 'string', analyzer: 'snowball'
        indexes :service_areas, index: 'not_analyzed'
      end
    end
  end

  def self.search(params = {})
    # if params[:keyword].blank? && params[:location].blank? && params[:language].blank?
    # #   error!({
    # #     "error" => "bad request",
    # #     "description" => "Either keyword, location, or language is missing."
    # #   }, 400)
    # end

    # Google provides a "bounds" option to restrict the address search to
    # a particular area. Since this app focuses on organizations in San Mateo
    # County, we use SMC_BOUNDS to restrict the search.
    result = Geocoder.search(params[:location], bounds: SMC_BOUNDS) if params[:location].present?
    # Google returns the coordinates as [lat, lon], but the geo_distance filter
    # below expects [lon, lat], so we need to reverse them.
    coords = result.first.coordinates.reverse if result.present?

    begin
      tire.search(page: params[:page], per_page: Location.per_page(params[:per_page])) do
        query do
          if params[:keyword].present?
            custom_filters_score do
              query do
                boolean do
                  must do
                    match [
                      :name, :description, 'organization.name',
                      'services.keywords', 'services.name', 'services.description',
                      'services.categories.name'
                    ], params[:keyword]
                  end
                  should do
                    term 'name.exact', params[:keyword], boost: 30
                    prefix 'name.exact', params[:keyword], boost: 5
                    term 'services.keywords.exact', params[:keyword], boost: 20
                    term 'services.categories.name.exact', params[:keyword], boost: 20
                    match [
                      :name, :description, 'organization.name',
                      'services.keywords', 'services.name', 'services.description',
                      'services.categories.name'
                    ], params[:keyword], slop: 0, boost: 15, type: 'phrase'
                  end
                end
              end
              if params[:location].present?
                filter do
                  filter :term, 'address.city' => params[:location].
                    split(',')[0].gsub('+', ' ').titleize
                  boost 50
                end
                filter do
                  filter :term, 'address.zip' => params[:location]
                  boost 50
                end
              end
              filter do
                filter :term, 'organization.name.exact' => 'San Mateo County Human Services Agency'
                boost 30
              end
              # filter do
              #   filter :geo_distance_range, :from => "0mi", :to => "5mi", coordinates: coords
              #   boost 30
              # end
              score_mode 'total'
            end
          end
          match [:admin_emails, 'emails.exact'], params[:email] if params[:email].present?

          generic_domains = %w(gmail.com aol.com sbcglobal.net hotmail.com yahoo.com co.sanmateo.ca.us smcgov.org)
          if params[:domain].present? && generic_domains.include?(params[:domain])
            match 'emails.exact', params[:domain]
          elsif params[:domain].present?
            match [:urls, 'emails.domain'], params[:domain]
          end

          filtered do
            filter :geo_distance, coordinates: coords, distance: "#{Location.current_radius(params[:radius])}miles" if params[:location].present?
            # filter :geo_bounding_box, coordinates: { :top_left => "37.7084,-122.521", :bottom_right => "37.1066,-122.08" }
            filter :term, languages: params[:language].downcase if params[:language].present?
            filter :missing, field: 'services.categories' if params[:include] == 'no_cats'
            filter :term, 'services.categories.name.exact' => params[:category] if params[:category].present?
            filter :term, 'organization.name.exact' => params[:org_name] if params[:org_name].present?
            filter :terms, 'services.service_areas' => SMC_SERVICE_AREAS if params[:service_area] == 'smc'
          end
        end
        sort do
          by :_geo_distance, coordinates: coords, unit: 'mi', order: 'asc' if params[:location].present?
          by :created_at, 'desc' if params[:keyword].blank? && params[:location].blank? && params[:language].blank?
        end
      end
    rescue Tire::Search::SearchRequestFailed
      error!(
        {
          'error' => 'bad request',
          'description' => 'Invalid ZIP code or address.'
        },
        400
      )
    end
  end

  def self.error!(message, status = 403)
    throw :error, message: message, status: status
  end

  def self.current_radius(radius)
    if radius.present?
      begin
        radius = Float radius.to_s
        # radius must be between 0.1 miles and 50 miles
        [[0.1, radius].max, 50].min
      rescue ArgumentError
        error!(
          {
            'error' => 'bad request',
            'description' => 'radius must be a number.'
          },
          400
        )
      end
    else
      5
    end
  end

  def self.per_page(params)
    if params.to_i > 100
      100
    else
      params.to_i if params.present?
    end
  end

  def self.nearby(loc, params = {})
    coords = loc.coordinates
    distance = params[:radius] ? Location.current_radius(params[:radius]) : 0.5
    if coords.present?
      tire.search(page: params[:page], per_page: Rails.env.test? ? 1 : 30) do
        query do
          filtered do
            filter :geo_distance, coordinates: coords, distance: "#{distance}miles"
            filter :not, ids: { values: ["#{loc.id}"] }
          end
        end
        sort do
          by :_geo_distance, coordinates: coords, unit: 'mi', order: 'asc'
        end
      end
    else
      # If location has no coordinates, the search above will raise
      # an exception, so we return an empty results list instead.
      tire.search do
        query do
          string 'sfdadf'
        end
      end
    end
  end

  def url
    "#{ENV['API_BASE_URL']}locations/#{id}"
  end

  SMC_SERVICE_AREAS = [
    'San Mateo County', 'Atherton', 'Belmont', 'Brisbane', 'Burlingame', 'Colma',
    'Daly City', 'East Palo Alto', 'Foster City', 'Half Moon Bay',
    'Hillsborough', 'Menlo Park', 'Millbrae', 'Pacifica', 'Portola Valley',
    'Redwood City', 'San Bruno', 'San Carlos', 'San Mateo',
    'South San Francisco', 'Woodside', 'Broadmoor', 'Burlingame Hills',
    'Devonshire', 'El Granada', 'Emerald Lake Hills', 'Highlands-Baywood Park',
    'Kings Mountain', 'Ladera', 'La Honda', 'Loma Mar', 'Menlo Oaks', 'Montara',
    'Moss Beach', 'North Fair Oaks', 'Palomar Park', 'Pescadero',
    'Princeton-by-the-Sea', 'San Gregorio', 'Sky Londa', 'West Menlo Park'
  ].freeze
end
