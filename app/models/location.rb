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

  normalize_attributes :description, :emails, :hours, :name,
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
              message: '%{value} is not a valid email' } }

  validate :format_of_admin_email, if: proc { |l| l.admin_emails.is_a?(Array) }

  def format_of_admin_email
    return unless admin_emails.present?
    regexp = /.+@.+\..+/i
    return unless admin_emails.find { |a| a.match(regexp).nil? }
    errors[:base] << 'admin_emails must be an array of valid email addresses'
  end

  def full_physical_address
    return unless address.present?
    "#{address.street}, #{address.city}, #{address.state} #{address.zip}"
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

  ## POSTGRES FULL-TEXT SEARCH
  scope :has_language, ->(l) { where('languages @@ :q', q: l) if l.present? }
  scope :has_keyword, ->(k) { keyword_search(k) if k.present? }
  scope :has_category, ->(c) { joins(services: :categories).where(categories: { name: c }) if c.present? }

  scope :is_near, (lambda do |loc, lat_lng, r|
    if loc.present?
      result = Geocoder.search(loc, bounds: Settings.bounds)
      coords = result.first.coordinates if result.present?
      near(coords, current_radius(r))
    elsif lat_lng.present?
      begin
        coords = lat_lng.split(',').map { |f| Float(f) }
      rescue ArgumentError
        error_msg = 'lat_lng must be a comma-delimited lat,long pair of floats'
        error!(error_msg, 400)
      end
      near(coords, current_radius(r))
    end
  end)

  scope :belongs_to_org, (lambda do |org|
    if org.present?
      joins(:organization).where('organizations.name @@ :q', q: org)
    end
  end)

  scope :has_email, ->(e) { where('admin_emails @@ :q or emails @@ :q', q: e) if e.present? }

  scope :has_domain, (lambda do |domain|
    domain = domain.split('@').last if domain.present?

    if domain.present? && Settings.generic_domains.include?(domain)
      Location.none
    elsif domain.present?
      where('urls ilike :q or emails ilike :q', q: "%#{domain}%")
    end
  end)

  include PgSearch

  pg_search_scope :keyword_search,
                  against: :tsv_body,
                  using: {
                    tsearch: {
                      dictionary: 'english',
                      any_word: false,
                      prefix: true,
                      tsvector_column: 'tsv_body'
                    }
                  }

  def self.text_search(params = {})
    Location.has_language(params[:language]).
            has_category(params[:category]).
            belongs_to_org(params[:org_name]).
            has_email(params[:email]).
            has_domain(params[:domain]).
            is_near(params[:location], params[:lat_lng], params[:radius]).
            has_keyword(params[:keyword])
  end

  def self.current_radius(radius)
    if radius.present?
      begin
        radius = Float radius.to_s
        # radius must be between 0.1 miles and 50 miles
        [[0.1, radius].max, 50].min
      rescue ArgumentError
        message = {
          'error' => 'bad request',
          'description' => 'radius must be a number.'
        }
        error!(message, 400)
      end
    else
      5
    end
  end

  # Kaminari setting for maximum number or results to return per page.
  max_paginates_per 100

  def self.error!(message, status = 403)
    throw :error, message: message, status: status
  end

  def url
    "#{ENV['API_BASE_URL']}locations/#{id}"
  end
end
