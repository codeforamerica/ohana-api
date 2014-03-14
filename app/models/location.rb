class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  extend Enumerize

  paginates_per Rails.env.test? ? 1 : 30

  attr_accessible :accessibility, :address, :ask_for, :contacts, :description,
                  :emails, :faxes, :hours, :kind, :languages, :mail_address,
                  :name, :phones, :short_desc, :transportation, :urls,
                  :contacts_attributes, :mail_address_attributes,
                  :address_attributes, :products, :payments, :market_match,
                  :organization_id

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

  normalize_attributes :description, :hours, :kind, :name,
    :short_desc, :transportation, :urls

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
  enumerize :kind, in: [:arts, :clinics, :education, :entertainment,
    :farmers_markets, :government, :human_services, :libraries, :museums,
    :other, :parks, :sports, :test]

  field :languages, type: Array
  # enumerize :languages, in: [:arabic, :cantonese, :french, :german,
  #   :mandarin, :polish, :portuguese, :russian, :spanish, :tagalog, :urdu,
  #   :vietnamese,
  #    ], multiple: true

  field :name
  slug :name, history: true

  field :phones, type: Array

  field :short_desc
  field :transportation

  field :urls, type: Array

  # farmers markets
  field :market_match, type: Boolean
  field :products, type: Array
  field :payments, type: Array

  # This is where you define all the fields that you want to be required
  # when uploading a dataset or creating a new entry via an admin interface.
  # You can separate the required fields with a comma. For example:
  # validates_presence_of :name, :hours, :phones

  validates_presence_of :name
  validates_presence_of :description
  validate :address_presence

  ## Uncomment the line below if you want to require a short description.
  ## We recommend having a short description so that web clients can display
  ## an overview within the search results. See smc-connect.org as an example.
  #validates_presence_of :short_desc

  ## Uncomment the line below if you want to limit the
  ## short description's length. If you want to display a short description
  ## on a front-end client like smc-connect.org, we recommmend writing or
  ## re-writing a description that's one to two sentences long, with a
  ## maximum of 200 characters. This is just a recommendation though.
  ## Feel free to modify the maximum below, and the way the description is
  ## displayed in the ohana-web-search client to suit your needs.
  #validates_length_of :short_desc, :maximum => 200

  # These are custom validations for values within arrays and hashes.
  # For example, the faxes field is an array that can contain multiple faxes.
  # To be able to validate each fax number in the array, we have to use a
  # custom array validator.
  # Both custom validators are defined in app/validators/
  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: "%{value} is not a valid URL" } }

  validates :emails, array: {
    format: { with: /.+@.+\..+/i,
              allow_blank: true,
              message: "%{value} is not a valid email" } }

  validates :phones, hash:  {
    format: { with: /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/,
              allow_blank: true,
              message: "%{value} is not a valid US phone number" } }

  # validates :faxes, hash:  {
  #   format: { with: /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/,
  #             allow_blank: true,
  #             message: "%{value} is not a valid US fax number" } }

  after_validation :reset_coordinates, if: :address_blank?

  validate :fax_format

  def fax_format
    if faxes.is_a?(String)
      errors[:base] << "Fax must be an array of hashes with number (required) and department (optional) attributes"
    elsif faxes.is_a?(Array)
      faxes.each do |fax|
        if !fax.is_a?(Hash)
          errors[:base] << "Fax must be a hash with number (required) and department (optional) attributes"
        elsif fax.is_a?(Hash)
          if fax["number"].blank?
            errors[:base] << "Fax hash must have a number attribute"
          else
            regexp = /\A(\((\d{3})\)|\d{3})[ |\.|\-]?(\d{3})[ |\.|\-]?(\d{4})\z/
            if fax["number"].match(regexp).nil?
              errors[:base] << "Please enter a valid US fax number"
            end
          end
        end
      end
    end
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

  def full_physical_address
    if self.address.present?
      "#{self.address.street}, #{self.address.city}, #{self.address.state} "+
      "#{self.address.zip}"
    end
  end

  def address_blank?
    self.address.blank?
  end

  def reset_coordinates
    self.coordinates = nil
  end

  include Geocoder::Model::Mongoid
  geocoded_by :full_physical_address           # can also be an IP address

  # Only call Google's geocoding service if the address has changed
  # to avoid unnecessary requests that affect our rate limit.
  after_validation :geocode, if: :needs_geocoding?

  def needs_geocoding?
    if self.address.present?
      self.address.changed? || self.coordinates.nil?
    end
  end

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
        :methods => ['url'],
      :include => {
        :services => { :except => [:location_id, :created_at],
          :methods => ['categories'] },
        :organization => { :methods => ['url', 'locations_url'] },
        :address => { :except => [:_id] },
        :mail_address => { :except => [:_id] },
        :contacts => { :except => [] }
      })
    hash.merge!("slugs" => _slugs) if _slugs.present?
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

    # remove service_ids and category_ids fields to speed up response time.
    # clients don't need them.
    if obj["services"].present?
      obj["services"].each do |s|
        s.reject! { |k,_| k == "category_ids" }
        if s["categories"].present?
          s["categories"].each { |c| c.reject! { |k,_| k == "service_ids" } }
        end
      end
    end
  end

  settings :number_of_shards => 1,
           :number_of_replicas => 1,
    :analysis => {
      :tokenizer => {
        :extract_url_domain => {
          "pattern"   => "(http|https):\/\/(www.)?([^\/]+)",
          "group"     => "3",
          "type"      => "pattern"
        },
        :extract_email_domain => {
          "pattern"   => ".+@(.+)",
          "group"     => "1",
          "type"      => "pattern"
        }
      },
      :analyzer => {
        :url_analyzer => {
          "tokenizer" => "extract_url_domain",
          "type" => "custom"
        },
        :email_analyzer => {
          "tokenizer" => "extract_email_domain",
          "type" => "custom"
        }
      }
    } do

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
      indexes :emails, type: "multi_field",
        fields: {
          exact:  { type: "string", index: "not_analyzed" },
          domain: { type: "string", index_analyzer: "email_analyzer", search_analyzer: "keyword" }
        }
      indexes :urls, type: "string", index_analyzer: "url_analyzer", search_analyzer: "keyword"

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
        match "emails.exact", params[:email] if params[:email].present?

        generic_domains = %w(gmail.com aol.com sbcglobal.net hotmail.com yahoo.com co.sanmateo.ca.us smcgov.org)
        if params[:domain].present? && generic_domains.include?(params[:domain])
          match "emails.exact", params[:domain]
        elsif params[:domain].present?
          match [:urls, "emails.domain"], params[:domain]
        end

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
          filter :missing, field: 'services.categories' if params[:include] == "no_cats"
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

  # This allows you to display helpful error messages for attributes
  # of embedded objects, like contacts and address. For example,
  # the address model requires the state attribute to be exactly 2 characters.
  # See this line in app/models/address.rb:
  # validates_length_of :state, :maximum => 2, :minimum => 2
  # Without the custom validation below, if you try to create or update and
  # address with a state that has less than 2 characters, the default
  # error message will be "Address is invalid", which is not specific enough.
  # By adding this custom validation, we can make the error message more
  # helpful: "State is too short (minimum is 2 characters)".
  after_validation :handle_post_validation
  def handle_post_validation
    unless self.errors[:contacts].blank?
      self.contacts.each do |contact|
        contact.errors.each { |attr,msg| self.errors.add(attr, msg) }
      end
      self.errors.delete(:contacts)
    end

    unless self.errors[:address].blank?
      address.errors.each { |attr,msg| self.errors.add(attr, msg) }
      self.errors.delete(:address)
    end

    unless self.errors[:mail_address].blank?
      mail_address.errors.each { |attr,msg| self.errors.add(attr, msg) }
      self.errors.delete(:mail_address)
    end
  end
end
