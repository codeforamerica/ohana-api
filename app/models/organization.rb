class Organization < ActiveRecord::Base
  default_scope { order('id ASC') }

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
              message: '%{value} is not a valid URL' } }

  serialize :urls, Array

  auto_strip_attributes :name, squish: true

  paginates_per Rails.env.test? ? 1 : 30

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

  def url
    "#{ENV['API_BASE_URL']}organizations/#{id}"
  end

  def locations_url
    "#{ENV['API_BASE_URL']}organizations/#{id}/locations"
  end

  def domain_name
    URI.parse(urls.first).host.gsub(/^www\./, '') if urls.present?
  end

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :name
    expose :slug
    expose :url
    expose :locations_url
  end
end
