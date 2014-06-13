class Organization < ActiveRecord::Base
  attr_accessible :name, :urls

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

  has_many :locations, dependent: :destroy
  # accepts_nested_attributes_for :locations

  normalize_attributes :name

  serialize :urls, Array

  validates :name, presence: { message: "can't be blank for Organization" }

  paginates_per Rails.env.test? ? 1 : 30

  def url
    "#{ENV['API_BASE_URL']}organizations/#{id}"
  end

  def locations_url
    "#{ENV['API_BASE_URL']}organizations/#{id}/locations"
  end

  def domain_name
    URI.parse(urls.first).host.gsub(/^www\./, '') if urls.present?
  end

  default_scope { order('id ASC') }

  include Grape::Entity::DSL
  entity do
    expose :id
    expose :name
    expose :slug
    expose :url
    expose :locations_url
  end
end
