class Language
  include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps

  normalize_attributes :name

  field :name

  validates_presence_of :name
  has_and_belongs_to_many :locations
end
