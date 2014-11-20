class Location < ActiveRecord::Base
  attr_accessible :accessibility, :address, :admin_emails, :ask_for, :contacts,
                  :description, :emails, :faxes, :hours, :importance, :kind,
                  :languages, :latitude, :longitude, :mail_address,
                  :market_match, :name, :payments, :phones, :products,
                  :short_desc, :transportation, :urls,
                  :address_attributes, :contacts_attributes, :faxes_attributes,
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

  validates :kind, :organization, :name,
            presence: { message: I18n.t('errors.messages.blank_for_location') }

  validates :description,
            presence: { message: I18n.t('errors.messages.blank_for_location') },
            unless: proc { |loc| loc.kind == 'farmers_markets' }

  ## Currently, the short description field is limited to 200 characters.
  ## Change the value below to increase or decrease the limit.
  # validates :short_desc, length: { maximum: 200 }

  # Custom validation for values within arrays.
  # For example, the urls field is an array that can contain multiple URLs.
  # To be able to validate each URL in the array, we have to use a
  # custom array validator. See app/validators/array_validator.rb
  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: "%{value} #{I18n.t('errors.messages.invalid_url')}",
              allow_blank: true } }

  validates :emails, :admin_emails, array: {
    format: { with: /\A([^@\s]+)@((?:(?!-)[-a-z0-9]+(?<!-)\.)+[a-z]{2,})\z/i,
              message: "%{value} #{I18n.t('errors.messages.invalid_email')}",
              allow_blank: true } }

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

  # Don't change the terms here! You can change their display
  # name in config/locales/en.yml
  enumerize :kind,
            in: [:arts, :clinics, :education, :entertainment, :farmers_markets,
                 :government, :human_services, :libraries, :museums, :other,
                 :parks, :sports]

  # List of admin emails that should have access to edit a location's info.
  # Admin emails can be added to a location via the Admin interface.
  serialize :admin_emails, Array

  serialize :ask_for, Array
  serialize :emails, Array

  serialize :languages, Array
  # enumerize :languages, in: [:arabic, :cantonese, :french, :german,
  #   :mandarin, :polish, :portuguese, :russian, :spanish, :tagalog, :urdu,
  #   :vietnamese,
  #    ], multiple: true, scope: true

  serialize :products, Array
  serialize :payments, Array
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
