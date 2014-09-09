class Location < ActiveRecord::Base
  attr_accessible :accessibility, :address, :admin_emails, :contacts,
                  :description, :emails, :faxes, :hours, :languages,
                  :latitude, :longitude, :mail_address, :name, :phones,
                  :short_desc, :transportation, :urls, :address_attributes,
                  :contacts_attributes, :faxes_attributes,
                  :mail_address_attributes, :phones_attributes,
                  :services_attributes, :organization_id

  belongs_to :organization
  accepts_nested_attributes_for :organization

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true

  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts,
                                allow_destroy: true, reject_if: :all_blank

  has_many :faxes, dependent: :destroy
  accepts_nested_attributes_for :faxes,
                                allow_destroy: true, reject_if: :all_blank

  has_one :mail_address, dependent: :destroy
  accepts_nested_attributes_for :mail_address, allow_destroy: true

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  has_many :services, dependent: :destroy
  accepts_nested_attributes_for :services, allow_destroy: true

  # has_many :schedules, dependent: :destroy
  # accepts_nested_attributes_for :schedules

  validates :mail_address,
            presence: {
              message: I18n.t('errors.messages.no_address')
            },
            unless: proc { |loc| loc.address.present? }

  validates :address,
            presence: {
              message: I18n.t('errors.messages.no_address')
            },
            unless: proc { |loc| loc.mail_address.present? }

  validates :description, :organization, :name,
            presence: { message: I18n.t('errors.messages.blank_for_location') }

  ## Uncomment the line below if you want to require a short description.
  ## We recommend having a short description so that web clients can display
  ## an overview within the search results. See smc-connect.org as an example.
  # validates :short_desc, presence: { message: I18n.t('errors.messages.blank_for_location') }

  ## Uncomment the line below if you want to limit the
  ## short description's length. If you want to display a short description
  ## on a front-end client like smc-connect.org, we recommmend writing or
  ## re-writing a description that's one to two sentences long, with a
  ## maximum of 200 characters. This is just a recommendation though.
  ## Feel free to modify the maximum below, and the way the description is
  ## displayed in the ohana-web-search client to suit your needs.
  # validates :short_desc, length: { maximum: 200 }

  # Custom validation for values within arrays.
  # For example, the urls field is an array that can contain multiple URLs.
  # To be able to validate each URL in the array, we have to use a
  # custom array validator. See app/validators/array_validator.rb
  validates :urls, array: { url: true }

  validates :emails, :admin_emails, array: { email: true }

  # Only call Google's geocoding service if the address has changed
  # to avoid unnecessary requests that affect our rate limit.
  after_validation :geocode, if: :needs_geocoding?

  after_validation :reset_coordinates, if: proc { |l| l.address.blank? }

  geocoded_by :full_physical_address

  extend Enumerize
  serialize :accessibility, Array
  # Don't change the terms here! You can change their display
  # name in config/locales/en.yml
  enumerize :accessibility,
            in: [:cd, :deaf_interpreter, :disabled_parking, :elevator, :ramp,
                 :restroom, :tape_braille, :tty, :wheelchair, :wheelchair_van],
            multiple: true,
            scope: true

  # List of admin emails that should have access to edit a location's info.
  # Admin emails can be added to a location via the Admin interface.
  serialize :admin_emails, Array

  serialize :emails, Array

  serialize :urls, Array

  auto_strip_attributes :description, :hours, :name, :short_desc,
                        :transportation

  auto_strip_attributes :admin_emails, :emails, :urls,
                        reject_blank: true, nullify: false

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

  def full_physical_address
    return unless address.present?
    "#{address.street}, #{address.city}, #{address.state} #{address.zip}"
  end

  def coordinates
    [longitude, latitude] if longitude.present? && latitude.present?
  end

  def reset_coordinates
    self.latitude = nil
    self.longitude = nil
  end

  def needs_geocoding?
    address.changed? || latitude.nil? || longitude.nil? if address.present?
  end

  # See app/models/concerns/search.rb
  include Search
end
