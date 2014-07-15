class Organization < ActiveRecord::Base
  default_scope { order('id DESC') }

  attr_accessible :name, :urls

  has_many :locations, dependent: :destroy
  # accepts_nested_attributes_for :locations

  validates :name, presence: { message: "can't be blank for Organization" }

  # Custom validation for values within arrays.
  # For example, the urls field is an array that can contain multiple URLs.
  # To be able to validate each URL in the array, we have to use a
  # custom array validator. See app/validators/array_validator.rb
  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: '%{value} is not a valid URL', allow_blank: true } }

  serialize :urls, Array

  auto_strip_attributes :name, squish: true

  before_save :compact_urls

  def compact_urls
    return unless send('urls').is_a?(Array)
    send('urls=', send('urls').reject(&:blank?).map(&:squish))
  end

  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :domain_name]
    ]
  end

  def domain_name
    URI.parse(urls.first).host.gsub(/^www\./, '') if urls.present?
  end

  after_save :touch_locations

  private

  def touch_locations
    locations.find_each(&:touch)
  end
end
