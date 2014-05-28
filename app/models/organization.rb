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

  validates_presence_of :name, message: "can't be blank for Organization"

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

  # Remove once the Postgres migration is done and smc-connect has been updated
  def _slugs
    [slug]
  end

  include Grape::Entity::DSL
  entity do
    format_with(:slug_text) do |slugs|
      slugs.map(&:slug) if slugs.present?
    end

    expose :id
    expose :name
    expose :slug
    expose :slugs, format_with: :slug_text
    expose :_slugs
    expose :url
    expose :locations_url
  end
end
