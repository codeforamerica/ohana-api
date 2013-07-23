class Organization
  include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search

  normalize_attributes :name, :description, :services_provided

  field :name
  field :description
  field :services_provided

  field :emails, type: Array
  field :urls, type: Array
  field :funding_sources, type: Array

  validates_presence_of :name

  has_many :locations, dependent: :destroy
  #has_many :contacts, dependent: :destroy

  extend ValidatesFormattingOf::ModelAdditions

  validates :emails, array: {
    format: { with: /.+@.+\..+/i,
              message: "Please enter a valid email" } }

  validates :urls, array: {
    format: { with: /(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/i,
              message: "Please enter a valid URL" } }

  search_in :name, :description, :locations => [:name, :description, :keywords]
  #search_in :name, :description, :locations => :name

  # scope :find_by_keyword,
  #   lambda { |keyword| any_of(
  #     { name: /#{keyword.strip}s?\b/i },
  #     { keywords: /#{keyword.strip}s?\b/i },
  #     { agency: /#{keyword.strip}s?\b/i },
  #     { description: /#{keyword.strip}s?\b/i }) }

end
