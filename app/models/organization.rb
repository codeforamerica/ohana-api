class Organization < ActiveRecord::Base
  attr_accessible :name, :urls

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_many :locations, dependent: :destroy
  #accepts_nested_attributes_for :locations

  normalize_attributes :name

  serialize :urls, Array

  validates_presence_of :name

  paginates_per Rails.env.test? ? 1 : 30

  self.include_root_in_json = false

  after_save :refresh_tire_index
  def refresh_tire_index
    self.locations.each { |loc| loc.tire.update_index }
  end

  def url
    "#{root_url}organizations/#{self.id}"
  end

  def locations_url
    "#{root_url}organizations/#{self.id}/locations"
  end

  def root_url
    Rails.application.routes.url_helpers.root_url
  end

  include Grape::Entity::DSL
  entity do
    # format_with(:slug_text) do |slugs|
    #   slugs.map(&:slug) if slugs.present?
    # end

    expose :id
    expose :name
    #expose :slugs, :format_with => :slug_text
    expose :slug
    expose :url
    expose :locations_url
  end

end
