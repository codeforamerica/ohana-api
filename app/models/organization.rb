class Organization
  include RocketPants::Cacheable
  include Mongoid::Document
  include Mongoid::Timestamps

  normalize_attributes :name

  field :name

  validates_presence_of :name

  has_many :programs, dependent: :destroy
  #embeds_many :programs
  #accepts_nested_attributes_for :programs

end
