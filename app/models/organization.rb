class Organization
  #include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :locations, dependent: :destroy
  #embeds_many :locations
  #accepts_nested_attributes_for :locations

  normalize_attributes :name

  field :name
  field :urls, type: Array

  validates_presence_of :name

  paginates_per Rails.env.test? ? 1 : 30

  def url
    "#{Rails.application.routes.url_helpers.root_url}organizations/#{self.id}"
  end

end
