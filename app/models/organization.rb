class Organization < ActiveRecord::Base
  default_scope { order('id DESC') }

  attr_accessible :name, :urls

  has_many :locations, dependent: :destroy
  # accepts_nested_attributes_for :locations

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_org') },
            uniqueness: { case_sensitive: false }

  # Custom validation for values within arrays.
  # For example, the urls field is an array that can contain multiple URLs.
  # To be able to validate each URL in the array, we have to use a
  # custom array validator. See app/validators/array_validator.rb
  validates :urls, array: { url: true }

  serialize :urls, Array

  auto_strip_attributes :name
  auto_strip_attributes :urls, reject_blank: true, nullify: false

  extend FriendlyId
  friendly_id :name, use: [:history]

  def domain_name
    URI.parse(urls.first).host.gsub(/^www\./, '') if urls.present?
  end

  after_save :touch_locations

  private

  def touch_locations
    locations.find_each(&:touch)
  end
end
