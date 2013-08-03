class Program
  include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search

  search_in :name, :description, :locations => :keywords, :organization => :name

  # embedded_in :organization
  belongs_to :organization
  validates_presence_of :organization

  # embeds_many :locations
  # accepts_nested_attributes_for :locations
  has_many :locations, dependent: :destroy

  #has_many :contacts, dependent: :destroy
  embeds_many :contacts
  accepts_nested_attributes_for :contacts

  normalize_attributes :audience, :description, :eligibility, :fees,
    :how_to_apply, :name, :short_desc, :urls

  field :audience
  field :description
  field :eligibility
  field :fees
  field :how_to_apply
  field :name
  field :short_desc

  field :funding_sources, type: Array
  field :urls, type: Array

  validates_presence_of :name, :description

  extend ValidatesFormattingOf::ModelAdditions

  validates :urls, array: {
    format: { with: %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i,
              message: "Please enter a valid URL" } }

end
