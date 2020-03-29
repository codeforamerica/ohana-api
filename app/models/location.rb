class Location < ApplicationRecord
  belongs_to :organization, optional: false

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true

  has_many :contacts, dependent: :destroy

  has_one :mail_address, dependent: :destroy, inverse_of: :location
  accepts_nested_attributes_for :mail_address, allow_destroy: true

  has_many :phones, dependent: :destroy, inverse_of: :location
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  has_many :services, dependent: :destroy

  has_many :regular_schedules, dependent: :destroy, inverse_of: :location
  accepts_nested_attributes_for :regular_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :holiday_schedules, dependent: :destroy, inverse_of: :location
  accepts_nested_attributes_for :holiday_schedules,
                                allow_destroy: true, reject_if: :all_blank

  validates :address,
            presence: { message: I18n.t('errors.messages.no_address') },
            unless: :virtual?

  validates :description, :name,
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

  validates :website, url: true, allow_blank: true

  validates :languages, pg_array: true

  validates :admin_emails, array: { email: true }

  validates :email, email: true, allow_blank: true

  after_validation :geocode, if: :needs_geocoding?
  after_validation :downcase_admin_emails
  after_validation :remove_duplicates

  geocoded_by :full_physical_address

  extend Enumerize
  serialize :accessibility, Array
  # Don't change the terms here! You can change their display
  # name in config/locales/en.yml
  enumerize :accessibility,
            in: %i[cd deaf_interpreter disabled_parking elevator ramp
                   restroom tape_braille tty wheelchair wheelchair_van],
            multiple: true

  auto_strip_attributes :description, :email, :name, :short_desc,
                        :transportation, :website

  auto_strip_attributes :admin_emails, reject_blank: true, nullify: true, nullify_array: false

  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      %i[name address_street],
      %i[name mail_address_city]
    ]
  end

  def address_street
    address.address_1 if address.present?
  end

  def mail_address_city
    mail_address.city if mail_address.present?
  end

  def full_physical_address
    return if address.blank?

    "#{address.address_1}, #{address.city}, #{address.state_province} #{address.postal_code}"
  end

  def needs_geocoding?
    return false if address.blank? || address.marked_for_destruction?
    return true if latitude.blank? && longitude.blank?

    address.changed? && !address.new_record?
  end

  def downcase_admin_emails
    admin_emails&.map!(&:downcase)
  end

  def remove_duplicates
    admin_emails&.uniq!
  end

  # See app/models/concerns/search.rb
  include Search
end
